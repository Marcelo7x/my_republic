import 'package:brothers_home/source/core/services/jwt/jwt_service.dart';
import 'package:brothers_home/source/modules/invoice/erros/invoice%20_exception.dart';

abstract class InvoiceDatasource {
  Future<void> insertInvoice(Map<String, dynamic> invoiceParams, List columns);
  Future<void> updateInvoice(Map<String, dynamic> invoiceParams, List columns);
  Future<List<Map<String, dynamic>?>> getInvoicesFromHomeid(int homeid);
  Future<List<Map<String, dynamic>>> getInvoicesFromHomeidByDateInterval(
      int homeid, startDate, endDate);
  Future<void> deleteInvoice(int userid, int invoiceid);
}

class InvoiceRepository {
  final InvoiceDatasource _datasource;
  final JwtService _jwt;

  InvoiceRepository(this._datasource, this._jwt);

  Future<void> insertInvoice(token, Map<String, dynamic> invoiceParams) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null || payload['homeid'] == null) {
      throw InvoiceException(403, "Invalid credetials");
    }

    invoiceParams['userid'] = payload['userid'];
    invoiceParams['homeid'] = payload['homeid'];

    final columns = invoiceParams.keys
        .map(
          (key) => '$key',
        )
        .toList();

    await _datasource.insertInvoice(invoiceParams, columns);
  }

  Future<void> updateInvoice(token, Map<String, dynamic> invoiceParams) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null || payload['homeid'] == null) {
      throw InvoiceException(403, "Invalid credetials");
    }

    invoiceParams['userid'] = payload['userid'];
    invoiceParams['homeid'] = payload['homeid'];

    final columns = invoiceParams.keys
        .where((key) => key != 'invoiceid')
        .map(
          (key) => '$key = @$key',
        )
        .toList();

    try {
      await _datasource.updateInvoice(invoiceParams, columns);
    } catch (e) {
      throw InvoiceException(403, 'Erro');
    }
  }

  Future<List<Map<String, dynamic>?>> getInvoicesFromHomeid(token) async {
    final payload = _jwt.getPayload(token);

    if (payload['homeid'] == null) {
      throw InvoiceException(403, "Invalid homeid");
    }

    try {
      List<Map<String, dynamic>?> result = await _datasource
          .getInvoicesFromHomeid(payload['homeid']);

      if (result == null) {
        throw InvoiceException(403, "Error");
      }

      return result;
    } on InvoiceException catch (e) {
      throw InvoiceException(e.statusCode, e.message);
    }
  }

  Future<List<Map<String, dynamic>?>> getInvoicesFromHomeidByDateInterval(
      token, Map<String, dynamic> invoiceParams) async {
    final payload = _jwt.getPayload(token);

    if (payload['homeid'] == null) {
      throw InvoiceException(403, "Invalid credetials");
    }

    if (invoiceParams['start_date'] == null || invoiceParams['end_date'] == null) {
      throw InvoiceException(403, "invalid Credetials");
    }

    try {
      List<Map<String, dynamic>?> result =
          await _datasource.getInvoicesFromHomeidByDateInterval(
              payload['homeid'],
              invoiceParams['start_date'],
              invoiceParams['end_date']);

      if (result == null) {
        throw InvoiceException(403, "Error");
      }

      return result;
    } on InvoiceException catch (e) {
      throw InvoiceException(e.statusCode, e.message);
    }
  }

  Future<void> deleteInvoice(token, Map<String, dynamic> invoiceParams) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null) {
      throw InvoiceException(403, "Invalid credetials");
    }

    if (invoiceParams['invoiceid'] == null) {
      throw InvoiceException(403, "Invalid invoiceid");
    }

    try {
      await _datasource.deleteInvoice(int.parse(payload['userid']), int.parse(invoiceParams['invoiceid']));
    } on Exception catch (e) {
      throw InvoiceException(403, 'Erro ao deletar');
    }
  }
}
