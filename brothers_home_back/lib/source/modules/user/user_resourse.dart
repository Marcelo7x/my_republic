import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/services/encrypt/bcrypt_service_imp.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _listUsers),
        Route.get('/user/:userid', _getUser),
        Route.post('/user', _addUser),
        Route.put('/user', _updateUser),
        Route.delete('/user/:userid', _deleteUser),
        Route.post('/login', _login)
      ];

  FutureOr<Response> _addUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptServiceImp>();

    final userParams = (arguments.data as Map).cast<String, dynamic>();

    userParams['password'] = bcrypt.generatHash(userParams['password']);

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
        jsonEncode(<String,String>{'message': 'Usuário removido'}));
  }

  FutureOr<Response> _login(
      ModularArguments arguments, Injector injector) async {
    var result = await arguments.data;

    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result_bd;
    try {
      result_bd = await database.query(
          'SELECT userId, homeid, name FROM "User" WHERE email = @email and password = @password',
          variables: {
            "email": result['email'],
            "password": result['password'],
          });
      print(result_bd);
    } catch (e) {
      print("Funçao _login");
      print(e);
      return Response.ok('Ops!!! Não conseguimos fazer login.\n');
    }

    final Map<String, dynamic> user = result_bd[0]["User"]!;
    print(user);

    return Response.ok(jsonEncode(user));
  }
}
