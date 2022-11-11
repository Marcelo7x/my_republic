import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_page.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/invoices/invoices_page.dart';
import 'package:frontend/app/modules/home/no_home/no_home_page.dart';
import 'package:frontend/app/modules/home/notifications/notifications_page.dart';
import 'package:frontend/app/modules/home/resume/resume_page.dart';
import 'package:frontend/app/modules/home/setting/options_page.dart';

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
    await Modular.get<HomeStore>().reload();
  }

  @override
  Widget build(BuildContext context) {
    final HomeStore homeController = Modular.get<HomeStore>();
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // Lista de contas
    List<Widget> listWidget = <Widget>[
      // const InvoicesPage(),
      const ResumePage(),
      const NotificationsPage(),
      OptionsPage(context: context, homeController: homeController),
    ];

    List<Widget> noHome = <Widget>[
      const NoHomePage(),
      NoHomePage(),
      const NotificationsPage(),
      OptionsPage(context: context, homeController: homeController),
    ];

    return Observer(
      builder: (_) {
        return Scaffold(
          body: Observer(builder: (_) {
            return SizedBox(
              width: width,
              height: height,
              child: Observer(builder: (_) {
                return PageView(
                  controller: homeController.page_controller,
                  children: homeController.isLiveInHome ? noHome : listWidget,
                  onPageChanged: (index) => homeController.setIndex(index),
                );
              }),
            );
          }),
          bottomNavigationBar: Observer(
            builder: (_) {
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
                    icon: Icon(Icons.notifications),
                    label: "Notificações",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: "Opções",
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
