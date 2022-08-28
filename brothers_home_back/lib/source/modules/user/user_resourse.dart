import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database_interface.dart';
import '../../core/services/encrypt/bcrypt_service_imp.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _listUsers, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.get('/user/:userid', _getUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.post('/user', _addUser),
        Route.put('/user', _updateUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.delete('/user/:userid', _deleteUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
      ];

  FutureOr<Response> _addUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptServiceImp>();

    final userParams = (arguments.data as Map).cast<String, dynamic>();

    userParams['password'] = bcrypt.generateHash(userParams['password']);

    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;

    try {
      result = await database.query(
          'INSERT INTO "User" (name,password,email) VALUES (@name, @password, @email) RETURNING userid, name, email, role',
          variables: {
            'name': userParams['name'],
            'password': userParams['password'],
            'email': userParams['email']
          });
    } catch (e) {
      print("funçao _addUser");
      print(e);
      return Response.notFound(
          jsonEncode({'erro': 'Ops!!! Não conseguimos adicionar o usuário.'}));
    }

    final List<Map<String, dynamic>?> user =
        result.map((e) => e["User"]).toList();
    return Response.ok(jsonEncode(user));
  }

  FutureOr<Response> _listUsers(Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result =
          await database.query('SELECT userid, name, email, role FROM "User"');
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> users =
        result!.map((e) => e["User"]).toList();

    return Response.ok(jsonEncode(users));
  }

  FutureOr<Response> _getUser(
      Injector injector, ModularArguments arguments) async {
    var database = injector.get<RemoteDatabase>();
    var params = await arguments.params;

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query(
          'SELECT userid, name, email, role FROM "User" WHERE userid = @id',
          variables: {
            'id': params['userid'],
          });
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> users =
        result!.map((e) => e["User"]).toList();

    return Response.ok(jsonEncode(users));
  }

  FutureOr<Response> _updateUser(
      Injector injector, ModularArguments arguments) async {
    var database = injector.get<RemoteDatabase>();
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    final columns = userParams.keys
        .where((key) => key != 'userid' || key != 'password')
        .map(
          (key) => '$key = @$key',
        )
        .toList();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query(
        'UPDATE "User" SET ${columns.join(',')}  WHERE userid = @userid RETURNING userid, email, role, name',
        variables: userParams,
      );
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> users =
        result?.map((e) => e["User"]).toList() ?? [];

    return Response.ok(jsonEncode(users));
  }

  FutureOr<Response> _deleteUser(
      ModularArguments arguments, Injector injector) async {
    final result = arguments.params;

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query('DELETE FROM "User" WHERE userid = @userid',
          variables: {'userid': result['userid']});
    } catch (e) {
      print("funçao _removeUser");
      print(e);
      return Response.notFound(
          jsonEncode({'erro': 'Ops!!! Não conseguimos remover o usuário.'}));
    }

    return Response.ok(
        jsonEncode(<String, String>{'message': 'Usuário removido'}));
  }
}
