import 'package:brothers_home/source/modules/invoice/datasource/invoice_datasource_impl.dart';
import 'package:brothers_home/source/modules/invoice/repository/invoice_repository.dart';
import 'package:brothers_home/source/modules/invoice/resource/invoice_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class InvoiceModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton<InvoiceDatasource>((i) => InvoiceDatasourceImpl(i())),
    Bind.singleton<InvoiceRepository>((i) => InvoiceRepository(i())),
  ];

  @override
  List<Route> get routes => [
    Route.resource(InvoiceResource())
  ];
}
