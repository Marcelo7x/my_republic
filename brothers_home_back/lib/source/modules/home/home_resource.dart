import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../services/database/remote_database_interface.dart';

class HomeResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/list-home', _listHome),
        Route.post('/add-home', _addHome),
        Route.post('/number-users', _number_of_users_for_home),
        Route.get('/list-categories', _listCategory),
      ];

  FutureOr<Response> _addHome(ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query(
          'INSERT INTO "Home" (name,street,district,city,state,country,number,cep) VALUES (@name, @street, @district, @city, @state, @country, @number, @cep)',
          variables: {
            'name': result['name'],
            'street': result['street'],
            'district': result['district'],
            'city': result['city'],
            'state': result['state'],
            'country': result['country'],
            'number': result['number'],
            'cep': result['cep']
          });
    } catch (e) {
      print("funçao _addHome");
      print(e);
      return Response.ok('Ops!!! Não conseguimos adicionar home.\n');
    }

    return Response.ok('Home adicionado\n');
  }

  FutureOr<Response> _listHome(Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query('SELECT * FROM "Home"');
    } catch (e) {
      print(e);
    }

    return Response.ok(jsonEncode(result!));
  }

  FutureOr<Response> _number_of_users_for_home(
      ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result_bd;
    try {
      result_bd = await database.query(
          'SELECT u.userid, u.name FROM "User" u INNER JOIN "Home" h ON u.homeId = h.homeId WHERE h.homeId = @homeId',
          variables: {
            "homeId": result['homeId'],
          });

      print(result_bd);
    } catch (e) {
      print("Funçao _number_of_users_for_home");
      print(e);
      return Response.ok(
          'Ops!!! Não conseguimos recuperar o numero de users.\n');
    }

    return Response.ok(jsonEncode(result_bd));
  }

  FutureOr<Response> _listCategory(Injector injector) async {
  var database = injector.get<RemoteDatabase>();

  List<Map<String, Map<String, dynamic>>>? result;
  try {
    result = await database.query('SELECT * FROM "Category"');
  } catch (e) {
    print(e);
  }

  final List<Map<String, dynamic>?> categories = result!.map((e) => e["Category"]).toList();

  return Response.ok(jsonEncode(categories));
}

}
