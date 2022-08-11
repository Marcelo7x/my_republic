import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:brothers_home/DB.dart';
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

  FutureOr<Response> _addUser(ModularArguments arguments) async {
    var result = arguments.data;

    var db = DB.instance;
    var database = await db.database;

    try {
      await database.query(
          'INSERT INTO users(name,password,email) VALUES (@name, @password, @email)',
          substitutionValues: {
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

  FutureOr<Response> _listUsers() async {
    var db = DB.instance;
    var database = await db.database;

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.mappedResultsQuery("SELECT * FROM users");
    } catch (e) {
      print(e);
    }

    return Response.ok(jsonEncode(result!));
  }

  FutureOr<Response> _removeUser(ModularArguments arguments) async {
    var result = arguments.data;

    var db = DB.instance;
    var database = await db.database;

    try {
      await database.query('DELETE FROM users WHERE email = @email',
          substitutionValues: {'email': result['email']});
    } catch (e) {
      print("funçao _removeUser");
      print(e);
      return Response.ok('Ops!!! Não conseguimos remover o usuário.\n');
    }

    return Response.ok('Usuário removido\n');
  }

  FutureOr<Response> _login(ModularArguments arguments) async {
    var result = await arguments.data;

    var db = DB.instance;
    var database = await db.database;

    List<Map<String, Map<String, dynamic>>>? result_bd;
    try {
      result_bd = await database.mappedResultsQuery(
          "SELECT userId, homeid, name FROM users WHERE email = @email and password = @password",
          substitutionValues: {
            "email": result['email'],
            "password": result['password'],
          });
      print(result_bd);
    } catch (e) {
      print("Funçao _login");
      print(e);
      return Response.ok('Ops!!! Não conseguimos fazer login.\n');
    }

    return Response.ok(jsonEncode(result_bd));
  }
}
