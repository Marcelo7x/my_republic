import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
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

    var id = Modular.args.data;
    var logo = AssetImage("images/logo.png");

    controller.get_invoices();

    void _selectRageDate() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Selecione o intevalo"),
            content: SfDateRangePicker(
              view: DateRangePickerView.year,
              initialSelectedRange: controller.dateRange,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs date) =>
                  controller.set_dateRange(date.value),
            ),
            actions: <Widget>[
              // define os botões na base do dialogo
              TextButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    List<Widget> _listWidget = <Widget>[
      Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                //header
                height: _height * 0.1,
                width: _width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.money_off),
                        Text(
                          "Contas do mês",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Observer(builder: (_) {
                            return Text(
                                "Intervalo: ${controller.dateRange.startDate?.day}/${controller.dateRange.startDate?.month}/${controller.dateRange.startDate?.year} a ${controller.dateRange.endDate?.day}/${controller.dateRange.endDate?.month}/${controller.dateRange.endDate?.year}");
                          }),
                          onTap: () => _selectRageDate(),
                        ),
                        GestureDetector(
                          onTap: () => _selectRageDate(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Observer(builder: (_) {
                return Container(
                  height: _height * .7, width: _width * .95,
                  child: controller.invoices != null &&
                          !controller.invoices!.isEmpty
                      ? ListView(
                          children: controller.invoices!
                              .map((e) => Container(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(e['invoice']['category'].toString()),
                                          Text("${e['invoice']['date'].day}/${e['invoice']['date'].month}"),
                                          Text(e['users']['name'].toString()),
                                        ],
                                      ),
                                    ),
                                    Text("${(int.parse(e['invoice']['price'])/100)}"),
                                  ],
                                )
                              ))
                              .toList(),
                        )
                      : const CircularProgressIndicator(),
                );
              })
            ],
          ),
        ),
      ),
      SafeArea(child: Text("Balanço")),
      SafeArea(child: Text("Opções")),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Observer(builder: (_) {
        return Container(
          width: _width,
          height: _height,
          child: _listWidget.elementAt(controller.selectedIndex),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Container(
          width: _width,
          child: Row(
            children: [
              Container(
                width: _width * 0.75,
                child: Observer(builder: (_) {
                  return BottomNavigationBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    currentIndex: controller.selectedIndex,
                    onTap: (index) => controller.setIndex(index),
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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
