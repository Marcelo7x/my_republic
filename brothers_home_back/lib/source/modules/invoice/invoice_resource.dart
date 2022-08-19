import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import '../../services/database/remote_database_interface.dart';

class InvoiceResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/invoice', _addInvoice),
        Route.put('/invoice', _modifyInvoice),
        Route.get('/invoice/:id', _listInvoices),
        Route.post('/invoice/date_interval', _listInvoicesDateInterval),
        Route.delete('/invoice/:id', _removeInvoice),
      ];

  FutureOr<Response> _addInvoice(
      ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    var description = result['description'] ?? '-';
    var categoryId = result['categoryid'] ?? '-';
    var price = result['price'] ?? '-';
    var date = result['date'] ?? '-';
    var image = result['image'] ?? '-';
    var userId = result['userid'] ?? '-';
    var homeId = result['homeid'] ?? '-';
    var paid = result['paid'];

    if (price.toString().contains('.') || price.toString().contains(',')) {
      return Response.ok('Ops!!! Não conseguimos adicionar a conta.\n');
    }

    try {
      await database.query(
          'INSERT INTO "Invoice" (invoiceId,description,categoryid,price,date,paid,image,userId,homeId) VALUES (DEFAULT, @description, @categoryid, @price, @date, @paid, @image, @userid, @homeid)',
          variables: {
            'description': description,
            'categoryid': categoryId,
            'price': price,
            'date': date,
            'image': image,
            'userid': userId,
            'homeid': homeId,
            'paid': paid
          });
    } catch (e) {
      print("Erro: funçao _addInvoice");
      print(e);
      return Response.ok('Ops!!! Não conseguimos adicionar a conta.\n');
    }

    return Response.ok(jsonEncode('Conta adicionada\n'));
  }

  FutureOr<Response> _modifyInvoice(
      ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

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
          'UPDATE "Invoice" SET description = @description, \"categoryId\" = @categoryId, price = @price, date = @date, image = @image, paid = @paid WHERE invoiceId = @invoiceId and userId = @userId',
          variables: {
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

  FutureOr<Response> _removeInvoice(
      ModularArguments arguments, Injector injector) async {
    var result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query(
          'DELETE FROM "Invoice" WHERE invoiceId = @invoiceId and userId = @userId',
          variables: {
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

  FutureOr<Response> _listInvoices(
      ModularArguments arguments, Injector injector) async {
    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query('SELECT * FROM "Invoice"');
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> invoices =
        result!.map((e) => e["Invoice"]).toList();

    return Response.ok(jsonEncode(invoices, toEncodable: (dynamic item) {
      if (item is DateTime) {
        return item.toIso8601String();
      }
      return item;
    }));
  }

  FutureOr<Response> _listInvoicesDateInterval(
      ModularArguments arguments, Injector injector) async {
    var _result = arguments.data;

    var database = injector.get<RemoteDatabase>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query(
          'SELECT i.invoiceid, i.userid, i.homeid, i.description, i.categoryid, i.price, i.date, i.image, i.fixed, i.paid, u.name, c.name FROM "Category" c INNER JOIN "Invoice" i ON c.categoryid = i.categoryid INNER JOIN "User" u ON i.homeid = u.homeid and @homeid = u.homeid and i.userid = u.userid  WHERE date >= @first_date and date <= @last_date ORDER BY i.date',
          variables: {
            'homeid': _result['homeid'],
            'first_date': _result['first_date'],
            'last_date': _result['last_date']
          });
    } catch (e) {
      print(e);
    }

    // final List<Map<String, dynamic>?> invoices = result!.map((e) {
    //   e["User"]!["name"] = {};

    //   Map<String, dynamic> m = <String, dynamic>{};
    //   m.addAll(e["Invoice"]!);
    //   m.addAll(e["User"]!);
    //   m.addAll(e["Category"]!);

    //   return m;
    // }).toList();

    return Response.ok(jsonEncode(result, toEncodable: (dynamic item) {
      if (item is DateTime) {
        return item.toIso8601String();
      }
      return item;
    }));
  }
}
