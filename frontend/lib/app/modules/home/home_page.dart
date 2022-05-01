import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
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

    Intl.defaultLocale = 'pt_BR';
    var numberFormat = NumberFormat('##0.00');

    var id = Modular.args.data;
    var logo = AssetImage("images/logo.png");

    controller.get_invoices();

    //Calendario para selecionar range de datas
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

    void _selectDate() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Selecione o dia"),
            content: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs date) =>
                  controller.set_date(date.value),
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

    //adicionar conta
    void _addInvoicePopup() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Adicionar Gasto"),
            contentPadding: const EdgeInsets.all(10),
            actionsPadding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: SingleChildScrollView(
              child: Container(
                height: _height * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  TextField(
                      controller: controller.category,
                      decoration: const InputDecoration(
                        label: Text("Adicione uma categoria"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      )),
                  TextField(
                      controller: controller.description,
                      decoration: const InputDecoration(
                        label: Text("Adicione uma descrição"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      )),
                  Row(
                    children: [
                      const Text(
                        "Selecione o dia: "
                      ),
                      GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              controller.date == null? "" : "${controller.date.day}/${controller.date.month}/${controller.date.year}",
                              style: const TextStyle(
                                color: Colors.blueAccent
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 3),
                              child: Icon(Icons.calendar_month, color: Colors.blueAccent),
                            )
                          ],
                        ),
                        onTap: () => _selectDate(),
                      ),
                    ],
                  ),
                  TextField(
                      controller: controller.price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Digite o valor"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      )),
                ]),
              ),
            ),
            actions: <Widget>[
              // define os botões na base do dialogo
              ElevatedButton(
                child: Text("Adicionar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Cancelar", style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // Lista de contas
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
                  height: _height * .75,
                  width: _width * .95,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: controller.invoices != null &&
                          controller.invoices!.isNotEmpty
                      ? ListView(
                          children: controller.invoices!
                              .map(
                                (e) => Container(
                                  height: 65,
                                  //margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      e['invoice']['category']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5)),
                                                    Text(
                                                      "${e['invoice']['date'].day}/${e['invoice']['date'].month}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  e['users']['name'].toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5, top: 7),
                                                child: Text(
                                                  "R\$",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${(numberFormat.format(int.parse(e['invoice']['price']) / 100))}",
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Divider(
                                          height: 5,
                                          thickness: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
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
        onPressed: () => _addInvoicePopup(),
        child: Icon(Icons.add),
      ),
    );
  }
}
