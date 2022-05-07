import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/addInvoicePopup.dart';
import 'package:frontend/app/modules/home/widget/balance_page.dart';
import 'package:frontend/app/modules/home/widget/invoices_page.dart';
import 'package:frontend/app/modules/home/widget/options_page.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:frontend/app/modules/home/widget/showInformationPopup.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    var numberFormat = NumberFormat('##0.00');

    var id = Modular.args.data;
    var logo = AssetImage("images/logo.png");

    controller.get_invoices();

    // Lista de contas
    List<Widget> _listWidget = <Widget>[
      InvoicesPage(context: context, controller: controller),
      BalancePage(context: context, controller: controller),
      OptionsPage(context: context, controller: controller),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Observer(builder: (_) {
        return Container(
          width: _width,
          height: _height,
          child: PageView(
            controller: controller.page_controller,
            children: _listWidget,
            onPageChanged: (index) => controller.setIndex(index),
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          width: _width,
          child: Row(
            children: [
              SizedBox(
                width: _width * 0.75,
                child: Observer(builder: (_) {
                  return BottomNavigationBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    currentIndex: controller.selectedIndex,
                    onTap: (index) => controller.setPageAndIndex(index),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.money_off),
                        label: "Contas",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.graphic_eq),
                        label: "Balanço",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: "Opções",
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddInvoicePopup(context: context, controller: controller);
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
