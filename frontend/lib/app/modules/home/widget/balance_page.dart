import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:intl/intl.dart';

Widget BalancePage({required BuildContext context, required HomeStore controller}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var numberFormat = NumberFormat('##0.00');
  
  return SafeArea(
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
                  Icon(Icons.graphic_eq),
                  Text(
                    "Balanço",
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SelectRageDatePopup(context: context, controller: controller);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SelectRageDatePopup(context: context, controller: controller);
                      },
                    ),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("Total do período: R\$ "),
                      ),
                      Text(
                        numberFormat.format(controller.total_invoice / 100),
                        style: const TextStyle(
                          fontSize: 28,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("Valor por morador: R\$ "),
                      ),
                      Text(
                        numberFormat.format(controller.total_invoice_person / 100),
                        style: const TextStyle(
                          fontSize: 28,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "Lançamento por Morador",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.users.map((e) {
                    return Container(
                      height: 30,
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(
                            255,
                            e['r'],
                            e['g'],
                            e['b'],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 120,
                      child: Text(
                        toBeginningOfSentenceCase(e['name'].toString())! +
                            " ${(e.values.first * 100).round().toString()}%",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList()),
                  Container(
                    width: _width * .8,
                    height: 25,
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: controller.users
                          .map(
                            (e) => Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                  255,
                                  e['r'],
                                  e['g'],
                                  e['b'],
                                ),
                              ),
                              width: _width * .8 * (e.values.first),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  
                  //category percents
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                      "Gasto por Categoria",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.category_percents.map((e) {
                    return Container(
                      height: 30,
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(
                            255,
                            e['r'],
                            e['g'],
                            e['b'],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 120,
                      child: Text(
                        toBeginningOfSentenceCase(e['name'].toString())! +
                            " ${(e['value'] * 100).round().toString()}%",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList()),
                  Container(
                    width: _width * .8,
                    height: 25,
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: controller.category_percents
                          .map(
                            (e) => Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                  255,
                                  e['r'],
                                  e['g'],
                                  e['b'],
                                ),
                              ),
                              width: _width * .8 * (e['value']),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}
