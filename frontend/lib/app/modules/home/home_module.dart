import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance_store.dart';
import 'package:frontend/app/modules/home/invoice_store.dart';
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
  ];
}