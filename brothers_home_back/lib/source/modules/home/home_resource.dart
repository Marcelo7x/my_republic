import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database_interface.dart';

class HomeResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/home', _listHome, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.post('/home', _addHome, middlewares: [AuthGuard()]),
        Route.get('/home/:id/users', _users_for_home,
            middlewares: [AuthGuard()]),
        Route.get('/category', _listCategory, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _addHome(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data).cast<String, dynamic>();

    var database = injector.get<RemoteDatabase>();

    final columns = userParams.keys
        .map(
          (key) => '$key',
        )
        .toList();
    List<Map<String, Map<String, dynamic>>> result =
        <Map<String, Map<String, dynamic>>>[{}];
    try {
      result = await database.query(
          'INSERT INTO "Home" (homeid,${columns.join(',')}) VALUES (DEFAULT, @${columns.join(',@')}) RETURNING homeid, name',
          variables: userParams);
    } catch (e) {
      print("Erro: funçao _addHOME");
      print(e);
      return Response.notFound(
          jsonEncode({'Ops!!! Não conseguimos adicionar a home.'}));
    }

    final List<Map<String, dynamic>?> home =
        result.map((e) => e["Home"]).toList();

    return Response.ok(jsonEncode(home));
  }

  FutureOr<Response> _listHome(Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>> result = [{}];
    try {
      result = await database.query('SELECT * FROM "Home"');
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> home =
        result.map((e) => e["Home"]).toList();

    return Response.ok(jsonEncode(home));
  }

  FutureOr<Response> _users_for_home(
      ModularArguments arguments, Injector injector) async {
    var userParams = (arguments.params).cast<String, dynamic>();

    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>> result = [{}];
    try {
      result = await database.query(
          'SELECT u.userid, u.name FROM "User" u INNER JOIN "Home" h ON u.homeid = h.homeid WHERE h.homeid = @homeid',
          variables: {
            "homeid": userParams['id'],
          });
    } catch (e) {
      print("Funçao _number_of_users_for_home");
      print(e);

      return Response.ok(
          'Ops!!! Não conseguimos recuperar o numero de users.\n');
    }

    final List<Map<String, dynamic>?> home =
        result.map((e) => e["User"]).toList();
    return Response.ok(jsonEncode(home));
  }

  FutureOr<Response> _listCategory(Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>> result = [{}];
    try {
      result = await database.query('SELECT * FROM "Category"');
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> categories =
        result.map((e) => e["Category"]).toList();

    return Response.ok(jsonEncode(categories));
  }
}
