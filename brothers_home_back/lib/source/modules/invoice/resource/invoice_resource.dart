import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:brothers_home/source/modules/invoice/erros/invoice%20_exception.dart';
import 'package:brothers_home/source/modules/invoice/repository/invoice_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class InvoiceResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/i', _insertInvoice, middlewares: [AuthGuard()]),
        Route.put('/i', _updateInvoice, middlewares: [AuthGuard()]),
        Route.get('/i/homeid/:homeid', _getInvoicesFromHomeid,
            middlewares: [AuthGuard()]),
        Route.get('/i/homeid/:homeid/start/:start_date/end/:end_date',
            _getInvoicesFromHomeidByDateInterval,
            middlewares: [AuthGuard()]),
        Route.delete('/i/invoiceid/:invoiceid', _deleteInvoice,
            middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _insertInvoice(
      ModularArguments arguments, Injector injector) async {
    final invoiceParams = (arguments.data as Map).cast<String, dynamic>();
    final invoiceRepository = injector.get<InvoiceRepository>();

    try {
      await invoiceRepository.insertInvoice(invoiceParams);
    } on InvoiceException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(jsonEncode({"menssage": "Ok"}));
  }

  FutureOr<Response> _updateInvoice(
      Injector injector, ModularArguments arguments) async {
    final invoiceParams = (arguments.data as Map).cast<String, dynamic>();
    final invoiceRepository = injector.get<InvoiceRepository>();

    try {
      await invoiceRepository.updateInvoice(invoiceParams);
    } on InvoiceException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(jsonEncode({"message": "Ok"}));
  }

  FutureOr<Response> _deleteInvoice(
      ModularArguments arguments, Injector injector) async {
    final invoiceParams = (arguments.params as Map).cast<String, dynamic>();

    final invoiceRepository = injector.get<InvoiceRepository>();

    try {
      await invoiceRepository.deleteInvoice(invoiceParams);
    } on InvoiceException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(
        jsonEncode(<String, String>{'message': 'Conta removida'}));
  }

  FutureOr<Response> _getInvoicesFromHomeid(
      ModularArguments arguments, Injector injector) async {
    final invoiceParams = (arguments.params).cast<String, dynamic>();

    final invoiceRepository = injector.get<InvoiceRepository>();

    try {
      List<Map<String, dynamic>?> invoices =
          await invoiceRepository.getInvoicesFromHomeid(invoiceParams);
      return Response.ok(jsonEncode(invoices, toEncodable: (dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      }));
    } on InvoiceException catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }

  FutureOr<Response> _getInvoicesFromHomeidByDateInterval(
      ModularArguments arguments, Injector injector) async {
    var invoiceParams = (arguments.params).cast<String, dynamic>();

    final invoiceRepository = injector.get<InvoiceRepository>();

    try {
      List<Map<String, dynamic>?> invoices = await invoiceRepository
          .getInvoicesFromHomeidByDateInterval(invoiceParams);
      return Response.ok(jsonEncode(invoices, toEncodable: (dynamic item) {
        if (item is DateTime) {
          return item.toIso8601String();
        }
        return item;
      }));
    } on InvoiceException catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }
}
