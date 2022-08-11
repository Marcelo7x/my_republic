import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/DB.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class InvoiceResource extends Resource {
  @override
  List<Route> get routes => [
    Route.post('/add-invoice', _addInvoice),
    Route.put('/modify-invoice', _modifyInvoice),
    Route.get('/list-invoices', _listInvoices),
    Route.post('/list-invoices-date-interval', _listInvoicesDateInterval),
    Route.delete('/remove-invoice', _removeInvoice),
  ];

  FutureOr<Response> _addInvoice(ModularArguments arguments) async {
  var result = arguments.data;

  var db = DB.instance;
  var database = await db.database;

  var description = result['description'] ?? '-';
  var categoryId = result['categoryId'] ?? '-';
  var price = result['price'] ?? '-';
  var date = result['date'] ?? '-';
  var image = result['image'] ?? '-';
  var userId = result['userId'] ?? '-';
  var homeId = result['homeId'] ?? '-';
  var paid = result['paid'];

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

  return Response.ok(jsonEncode('Conta adicionada\n'));
}

FutureOr<Response> _modifyInvoice(ModularArguments arguments) async {
  var result = arguments.data;

  var db = DB.instance;
  var database = await db.database;

  var description = result['description'] ?? '-';
  var categoryId = result['categoryId'] ?? '-';
  var price = result['price'] ?? '-';
  var date = result['date'] ?? '-';
  var image = result['image'] ?? '-';
  var userId = result['userId'] ?? '-';
  var invoiceId = result['invoiceId'] ?? '-';
  var paid = result['paid'];

  if (price.toString().contains('.') || price.toString().contains(',')) {
    return Response.ok('Ops!!! Não conseguimos modificar a conta.\n');
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

FutureOr<Response> _removeInvoice(ModularArguments arguments) async {
  var result = arguments.data;

  var db = DB.instance;
  var database = await db.database;

  try {
    await database.query(
        'DELETE FROM invoice WHERE invoiceId = @invoiceId and userId = @userId',
        substitutionValues: {
          'userId': result['userId'],
          'invoiceId': result['invoiceId'],
        });
  } catch (e) {
    print("funçao _removeInvoice");
    print(e);
    return Response.ok('Ops!!! Não conseguimos remover a conta.\n');
  }

  return Response.ok('Invoice removido\n');
}

FutureOr<Response> _listInvoices(ModularArguments arguments) async {
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

FutureOr<Response> _listInvoicesDateInterval(ModularArguments arguments) async {
  var _result = arguments.data;

  var db = DB.instance;
  var database = await db.database;

  List<Map<String, Map<String, dynamic>>>? result;
  try {
    result = await database.mappedResultsQuery(
        "SELECT i.invoiceid, i.userid, i.homeid, i.description, i.\"categoryId\", i.price, i.date, i.image, i.fixed, i.paid, u.name, c.name FROM category c INNER JOIN invoice i ON c.\"categoryId\" = i.\"categoryId\" INNER JOIN users u ON i.homeid = u.homeid and @homeid = u.homeid and i.userid = u.userid  WHERE date >= @first_date and date <= @last_date ORDER BY i.date",
        substitutionValues: {
          'homeid': _result['homeid'],
          'first_date': _result['first_date'],
          'last_date': _result['last_date']
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


}
