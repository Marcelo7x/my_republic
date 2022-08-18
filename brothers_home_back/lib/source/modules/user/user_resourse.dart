import 'dart:async';
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:brothers_home/source/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/services/encrypt/bcrypt_service_imp.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/list-users', _listUsers),
        Route.post('/add-user', _addUser),
        Route.delete('/remove-user', _removeUser),
        Route.post('/login', _login)
      ];

  FutureOr<Response> _addUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptServiceImp>();

    final result = (arguments.data as Map).cast<String, dynamic>();

    result['password'] = bcrypt.generatHash(result['password']); 

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query(
          'INSERT INTO "User" (name,password,email) VALUES (@name, @password, @email)',
          variables: {
            'name': result['name'],
            'password': result['password'],
            'email': result['email']
          });
    } catch (e) {
      print("funçao _addUser");
      print(e);
      return Response.ok('Ops!!! Não conseguimos adicionar o usuário.\n');
    }

    return Response.ok('Usuário adicionado\n');
  }

  FutureOr<Response> _listUsers(Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query('SELECT * FROM "User"');
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> users =
        result!.map((e) => e["User"]).toList();

    return Response.ok(jsonEncode(users));
  }

  FutureOr<Response> _removeUser(
      ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query('DELETE FROM "User" WHERE email = @email',
          variables: {'email': result['email']});
    } catch (e) {
      print("funçao _removeUser");
      print(e);
      return Response.ok('Ops!!! Não conseguimos remover o usuário.\n');
    }

    return Response.ok('Usuário removido\n');
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
