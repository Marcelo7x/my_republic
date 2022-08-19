import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import '../../services/database/remote_database_interface.dart';

class InvoiceResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/invoice', _addInvoice),
        Route.put('/invoice', _updateInvoice),
        Route.get('/invoice/:invoiceid', _listInvoices),
        Route.post('/invoice/date_interval', _listInvoicesDateInterval),
        Route.delete('/invoice/:invoiceid', _deleteInvoice),
      ];

  FutureOr<Response> _addInvoice(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    var database = injector.get<RemoteDatabase>();

    final columns = userParams.keys
        .map(
          (key) => '$key',
        )
        .toList();
    List<Map<String,Map<String,dynamic>>> result = <Map<String,Map<String,dynamic>>>[{}];
    try {
      result = await database.query(
          'INSERT INTO "Invoice" (invoiceId,${columns.join(',')}) VALUES (DEFAULT, @${columns.join(',@')}) RETURNING invoiceid, description',
          variables: userParams);
    } catch (e) {
      print("Erro: funçao _addInvoice");
      print(e);
      return Response.notFound(
          jsonEncode({'Ops!!! Não conseguimos adicionar a conta.'}));
    }

    final List<Map<String, dynamic>?> invoice =
        result.map((e) => e["Invoice"]).toList();

    return Response.ok(jsonEncode(invoice));
  }

FutureOr<Response> _updateInvoice(
      Injector injector, ModularArguments arguments) async {
    var database = injector.get<RemoteDatabase>();
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    final columns = userParams.keys
        .where((key) => key != 'invoiceid')
        .map(
          (key) => '$key = @$key',
        )
        .toList();

    List<Map<String, Map<String, dynamic>>> result = <Map<String,Map<String,dynamic>>>[{}];
    try {
      result = await database.query(
        'UPDATE "Invoice" SET ${columns.join(',')}  WHERE invoiceid = @invoiceid RETURNING invoiceid, description, paid, price',
        variables: userParams,
      );
    } catch (e) {
      print(e);
    }

    final List<Map<String, dynamic>?> invoice =
        result.map((e) => e["Invoice"]).toList();

    return Response.ok(jsonEncode(invoice));
  }

  FutureOr<Response> _deleteInvoice(
      ModularArguments arguments, Injector injector) async {
    final userParams = (arguments.params as Map).cast<String, dynamic>();

    var database = injector.get<RemoteDatabase>();

    try {
      await database.query('DELETE FROM "Invoice" WHERE invoiceid = @invoiceid',
          variables: {'invoiceid': userParams['invoiceid']});
    } catch (e) {
      print("funçao _removeInvoice");
      print(e);
      return Response.notFound(
          jsonEncode({'erro': 'Ops!!! Não conseguimos remover a conta.'}));
    }

    return Response.ok(
        jsonEncode(<String, String>{'message': 'Conta removida'}));
  }

  FutureOr<Response> _listInvoices(
      ModularArguments arguments, Injector injector) async {
    var database = injector.get<RemoteDatabase>();
    final userParams = (arguments.params as Map).cast<String, dynamic>();

    List<Map<String, Map<String, dynamic>>>? result;
    try {
      result = await database.query(
        'SELECT * FROM "Invoice" WHERE invoiceid = @invoiceid',
        variables: {'invoiceid': userParams['invoiceid']},
      );
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
