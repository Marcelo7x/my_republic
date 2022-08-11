import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/DB.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class HomeResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/list-home', _listHome),
        Route.post('/add-home', _addHome),
        Route.post('/number-users', _number_of_users_for_home),
        Route.get('/list-categories', _listCategory),
      ];

  FutureOr<Response> _addHome(ModularArguments arguments) async {
    var result = arguments.data;

    var db = DB.instance;
    var database = await db.database;

    try {
      await database.query(
          'INSERT INTO home(name,street,district,city,state,country,number,cep) VALUES (@name, @street, @district, @city, @state, @country, @number, @cep)',
          substitutionValues: {
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

  FutureOr<Response> _listHome() async {
    var db = DB.instance;
    var database = await db.database;

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.mappedResultsQuery("SELECT * FROM home");
    } catch (e) {
      print(e);
    }

    return Response.ok(jsonEncode(result!));
  }

  FutureOr<Response> _number_of_users_for_home(
      ModularArguments arguments) async {
    var result = arguments.data;

    var db = DB.instance;
    var database = await db.database;

    List<Map<String, Map<String, dynamic>>>? result_bd;
    try {
      result_bd = await database.mappedResultsQuery(
          "SELECT u.userid, u.name FROM users u INNER JOIN home h ON u.homeId = h.homeId WHERE h.homeId = @homeId ",
          substitutionValues: {
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

  FutureOr<Response> _listCategory() async {
  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result;
  try {
    result = await database.mappedResultsQuery("SELECT * FROM category");
  } catch (e) {
    print(e);
  }

  return Response.ok(jsonEncode(result!));
}

}
