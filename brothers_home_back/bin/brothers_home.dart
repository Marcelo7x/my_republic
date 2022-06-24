import 'dart:io';
import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:brothers_home/DB.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/add-user', _addUser)
  ..post('/add-home', _addHome)
  ..get('/list-users', _listUsers)
  ..get('/list-home', _listHome)
  ..post('/login', _login)
  ..post('/add-invoice', _addInvoice)
  ..post('/modify-invoice', _modifyInvoice)
  ..get('/list-invoices', _listInvoices)
  ..get('/list-categories', _listCategory)
  ..post('/list-invoices-date-interval', _listInvoicesDateInterval)
  ..post('/remove-user', _removeUser)
  ..post('/remove-invoice', _removeInvoice)
  ..post('/number-users', _number_of_users_for_home);

Response _rootHandler(Request req) {
  Map<String, dynamic> data = {
    "current_version": "0.0.4",
    "force_update": "0.0.4",
  };

  return Response.ok(jsonEncode(data));
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _addUser(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  try {
    await database.query(
        'INSERT INTO users(name,password,email) VALUES (@name, @password, @email)',
        substitutionValues: {
          'name': result[0]['name'],
          'password': result[0]['password'],
          'email': result[0]['email']
        });
  } catch (e) {
    print("funçao _addUser");
    print(e);
    return Response.ok('Ops!!! Não conseguimos adicionar o usuário.\n');
  }

  return Response.ok('Usuário adicionado\n');
}

Future<Response> _addHome(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  try {
    await database.query(
        'INSERT INTO home(name,street,district,city,state,country,number,cep) VALUES (@name, @street, @district, @city, @state, @country, @number, @cep)',
        substitutionValues: {
          'name': result[0]['name'],
          'street': result[0]['street'],
          'district': result[0]['district'],
          'city': result[0]['city'],
          'state': result[0]['state'],
          'country': result[0]['country'],
          'number': result[0]['number'],
          'cep': result[0]['cep']
        });
  } catch (e) {
    print("funçao _addHome");
    print(e);
    return Response.ok('Ops!!! Não conseguimos adicionar home.\n');
  }

  return Response.ok('Home adicionado\n');
}

Future<Response> _removeUser(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  try {
    await database.query('DELETE FROM users WHERE email = @email',
        substitutionValues: {'email': result[0]['email']});
  } catch (e) {
    print("funçao _removeUser");
    print(e);
    return Response.ok('Ops!!! Não conseguimos remover o usuário.\n');
  }

  return Response.ok('Usuário removido\n');
}

Future<Response> _listUsers(Request request) async {
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

Future<Response> _listHome(Request request) async {
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

Future<Response> _login(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result_bd;
  try {
    result_bd = await database.mappedResultsQuery(
        "SELECT userId, homeid, name FROM users WHERE email = @email and password = @password",
        substitutionValues: {
          "email": result[0]['email'],
          "password": result[0]['password'],
        });
    print(result_bd);
  } catch (e) {
    print("Funçao _login");
    print(e);
    return Response.ok('Ops!!! Não conseguimos fazer login.\n');
  }

  return Response.ok(jsonEncode(result_bd));
}

Future<Response> _number_of_users_for_home(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result_bd;
  try {
    result_bd = await database.mappedResultsQuery(
        "SELECT u.userid, u.name FROM users u INNER JOIN home h ON u.homeId = h.homeId WHERE h.homeId = @homeId ",
        substitutionValues: {
          "homeId": result[0]['homeId'],
        });
        
    print(result_bd);
  } catch (e) {
    print("Funçao _number_of_users_for_home");
    print(e);
    return Response.ok('Ops!!! Não conseguimos recuperar o numero de users.\n');
  }

  return Response.ok(jsonEncode(result_bd));
}

Future<Response> _addInvoice(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  var description = result[0]['description'] ?? '-';
  var categoryId = result[0]['categoryId'] ?? '-';
  var price = result[0]['price'] ?? '-';
  var date = result[0]['date'] ?? '-';
  var image = result[0]['image'] ?? '-';
  var userId = result[0]['userId'] ?? '-';
  var homeId = result[0]['homeId'] ?? '-';
  var paid = result[0]['paid'];

  if (price.toString().contains('.') || price.toString().contains(',')) {
    return Response.ok('Ops!!! Não conseguimos adicionar a conta.\n');
  }

  try {
    await database.query(
        'INSERT INTO invoice(invoiceId,description,\"categoryId\",price,date,paid,image,userId,homeId) VALUES (DEFAULT, @description, @categoryId, @price, @date, @paid, @image, @userId, @homeId)',
        substitutionValues: {
          'description': description,
          'categoryId': categoryId,
          'price': price,
          'date': date,
          'image': image,
          'userId': userId,
          'homeId': homeId,
          'paid': paid
        });
  } catch (e) {
    print("Erro: funçao _addInvoice");
    print(e);
    return Response.ok('Ops!!! Não conseguimos adicionar a conta.\n');
  }

  return Response.ok('Conta adicionada.\n');
}

Future<Response> _modifyInvoice(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  var description = result[0]['description'] ?? '-';
  var categoryId = result[0]['categoryId'] ?? '-';
  var price = result[0]['price'] ?? '-';
  var date = result[0]['date'] ?? '-';
  var image = result[0]['image'] ?? '-';
  var userId = result[0]['userId'] ?? '-';
  var invoiceId = result[0]['invoiceId'] ?? '-';
  var paid = result[0]['paid'];

  if (price.toString().contains('.') || price.toString().contains(',')) {
    return Response.ok('Ops!!! Não conseguimos adicionar a conta.\n');
  }

  try {
    await database.query(
        'UPDATE invoice SET description = @description, \"categoryId\" = @categoryId, price = @price, date = @date, image = @image, paid = @paid WHERE invoiceId = @invoiceId and userId = @userId',
        substitutionValues: {
          'description': description,
          'categoryId': categoryId,
          'price': price,
          'date': date,
          'image': image,
          'userId': userId,
          'invoiceId': invoiceId,
          'paid': paid
        });
  } catch (e) {
    print("Erro: funçao _modifyInvoice");
    print(e);
    return Response.ok('Ops!!! Não conseguimos modificar a conta.\n');
  }

  return Response.ok('Conta modificada\n');
}

Future<Response> _removeInvoice(Request request) async {
  var result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  try {
    await database.query(
        'DELETE FROM invoice WHERE invoiceId = @invoiceId and userId = @userId',
        substitutionValues: {
          'userId': result[0]['userId'],
          'invoiceId': result[0]['invoiceId'],
        });
  } catch (e) {
    print("funçao _removeInvoice");
    print(e);
    return Response.ok('Ops!!! Não conseguimos remover a conta.\n');
  }

  return Response.ok('Invoice removido\n');
}

Future<Response> _listInvoices(Request request) async {
  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result;
  try {
    result = await database.mappedResultsQuery("SELECT * FROM invoice");
  } catch (e) {
    print(e);
  }

  return Response.ok(jsonEncode(result!, toEncodable: (dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }));
}

Future<Response> _listInvoicesDateInterval(Request request) async {
  var _result = await request.readAsString().then((value) => jsonDecode(value));

  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result;
  try {
    result = await database.mappedResultsQuery(
        "SELECT i.invoiceid, i.userid, i.homeid, i.description, i.\"categoryId\", i.price, i.date, i.image, i.fixed, i.paid, u.name, c.name FROM category c INNER JOIN invoice i ON c.\"categoryId\" = i.\"categoryId\" INNER JOIN users u ON i.homeid = u.homeid and @homeid = u.homeid and i.userid = u.userid  WHERE date >= @first_date and date <= @last_date ORDER BY i.date",
        substitutionValues: {
          'homeid': _result[0]['homeid'],
          'first_date': _result[0]['first_date'],
          'last_date': _result[0]['last_date']
        });
  } catch (e) {
    print(e);
  }

  return Response.ok(jsonEncode(result!, toEncodable: (dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }));
}

Future<Response> _listCategory(Request request) async {
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

void main(List<String> args) async {
  //connection BD
  print("connectando BD...");
  var db = DB.instance;
  await db.database;

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final _handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
