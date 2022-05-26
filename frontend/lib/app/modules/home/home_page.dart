import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/widget/balance_page.dart';
import 'package:frontend/app/modules/home/widget/invoices_page.dart';
import 'package:frontend/app/modules/home/widget/options_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    await store.get_invoices();
    await store.get_categories();
    await store.calc_total();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    var numberFormat = NumberFormat('##0.00');

    var id = Modular.args.data;
    var logo = AssetImage("images/logo.png");

    //controller.get_invoices();
    //controller.get_categories();

    // Lista de contas
    List<Widget> _listWidget = <Widget>[
      InvoicesPage(context: context, controller: controller),
      BalancePage(context: context, controller: controller),
      OptionsPage(context: context, controller: controller),
    ];

    return Observer(
      builder: (_) {
        return Scaffold(
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
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            child: Observer(builder: (_) {
              return NavigationBar(
                height: _height * .09,
                onDestinationSelected: (index) =>
                    controller.setPageAndIndex(index),
                selectedIndex: controller.selectedIndex,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.money_off),
                    label: "Contas",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.graphic_eq),
                    label: "Balanço",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: "Opções",
                  ),
                ],
              );
            }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButton: controller.selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddInvoicePopup(
                          context: context, controller: controller);
                    },
                  ),
                  child: const Icon(Icons.add),
                )
              : Container(),
        );
      },
    );
  }
}
