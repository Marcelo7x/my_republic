import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/no_home/no_home_page.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => InvoiceStore()),
    Bind.lazySingleton((i) => HomeStore()),
    Bind.lazySingleton((i) => BalanceStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
    ChildRoute('/no_home', child: (_, args) => NoHomePage()),
  ];
}
