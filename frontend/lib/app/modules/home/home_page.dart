import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/widget/balance_page.dart';
import 'package:frontend/app/modules/home/widget/invoices_page.dart';
import 'package:frontend/app/modules/home/widget/options_page.dart';
import 'package:frontend/domain/invoice.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    await invoicesController.getInvoices();
    await invoicesController.getCategories();
    await invoicesController.calcTotal();
  }

  @override
  Widget build(BuildContext context) {
    final HomeStore homeController = Modular.get<HomeStore>();
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // Lista de contas
    List<Widget> listWidget = <Widget>[
      const InvoicesPage(),
      BalancePage(context: context, invoicesController: invoicesController),
      OptionsPage(context: context, homeController: homeController),
    ];

    return Observer(
      builder: (_) {
        return Scaffold(
          body: Observer(builder: (_) {
            return SizedBox(
              width: width,
              height: height,
              child: PageView(
                controller: homeController.page_controller,
                children: listWidget,
                onPageChanged: (index) => homeController.setIndex(index),
              ),
            );
          }),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            child: Observer(builder: (_) {
              return NavigationBar(
                height: height * .09,
                onDestinationSelected: (index) =>
                    homeController.setPageAndIndex(index),
                selectedIndex: homeController.selectedIndex,
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
          floatingActionButton: homeController.selectedIndex == 0
              ? FloatingActionButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddInvoicePopup();
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
