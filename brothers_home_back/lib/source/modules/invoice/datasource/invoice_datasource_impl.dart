import 'package:brothers_home/source/core/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/modules/invoice/repository/invoice_repository.dart';

class InvoiceDatasourceImpl extends InvoiceDatasource {
  final RemoteDatabase _database;

  InvoiceDatasourceImpl(RemoteDatabase this._database);

  @override
  Future<void> deleteInvoice(int userid, int invoiceid) async {
    await _database.query(
      'DELETE FROM "Invoice" WHERE invoiceid = @invoiceid and userid = @userid',
      variables: {'invoiceid': invoiceid, 'userid': userid},
    );
  }

  @override
  Future<List<Map<String, dynamic>?>> getInvoicesFromHomeid(int homeid) async {
    List<Map<String, Map<String, dynamic>>>? result = await _database.query(
      'SELECT * FROM "Invoice" WHERE homeid = @homeid',
      variables: {'invoiceid': homeid},
    );

    final List<Map<String, dynamic>?> invoices =
        result.map((e) => e["Invoice"]).toList();

    return invoices;
  }

  @override
  Future<List<Map<String, dynamic>>> getInvoicesFromHomeidByDateInterval(
      int homeid, startDate, endDate) async {
    List<Map<String, Map<String, dynamic>>> result = await _database.query(
      'SELECT i.invoiceid, i.userid, i.homeid, i.description, i.categoryid, i.price, i.date, i.image, i.fixed, i.paid, u.firstname, c.name FROM "Category" c INNER JOIN "Invoice" i ON c.categoryid = i.categoryid INNER JOIN "User" u ON i.homeid = u.homeid and @homeid = u.homeid and i.userid = u.userid  WHERE date >= @first_date and date <= @last_date ORDER BY i.date',
      variables: {
        'homeid': homeid,
        'first_date': startDate,
        'last_date': endDate,
      },
    );

    final List<Map<String, dynamic>> invoices = result.map((e) {
      Map<String, dynamic> l = {};
      l.addEntries(e['Invoice']!.entries);
      l.addEntries(e['Category']!.entries);
      l.addEntries(e['User']!.entries);
      return l;
    }).toList();

    return invoices;
  }

  @override
  Future<void> insertInvoice(
      Map<String, dynamic> invoiceParams, List columns) async {
    await _database.query(
        'INSERT INTO "Invoice" (invoiceid,${columns.join(',')}) VALUES (DEFAULT, @${columns.join(',@')})',
        variables: invoiceParams.cast<String, dynamic>(),);
  }

  @override
  Future<void> updateInvoice(
      Map<String, dynamic> invoiceParams, List columns) async {
    await _database.query(
      'UPDATE "Invoice" SET ${columns.join(',')}  WHERE invoiceid = @invoiceid',
      variables: invoiceParams,
    );
  }
}
