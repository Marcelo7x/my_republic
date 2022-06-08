import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:intl/intl.dart';

Widget BalancePage(
    {required BuildContext context, required HomeStore controller}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var numberFormat = NumberFormat('##0.00');

  return SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            //header
            height: _height * 0.1,
            width: _width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.graphic_eq),
                    Text(
                      "Balanço",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Intervalo: "),
                    GestureDetector(
                      child: Observer(builder: (_) {
                        return Text(
                            "${controller.dateRange.startDate?.day}/${controller.dateRange.startDate?.month}/${controller.dateRange.startDate?.year} a ${controller.dateRange.endDate?.day}/${controller.dateRange.endDate?.month}/${controller.dateRange.endDate?.year}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary));
                      }),
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SelectRageDatePopup(
                              context: context, controller: controller);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SelectRageDatePopup(
                              context: context, controller: controller);
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Observer(builder: (_) {
            return Card(
              child: Container(
                height: _height * .75,
                width: _width * .95,
                padding: const EdgeInsets.all(10),
                child: controller.invoices.isEmpty
                    ? RefreshIndicator(
                        onRefresh: () async => await controller.get_invoices(),
                        child: const Center(child: Text("Ainda não há contas")))
                    : SingleChildScrollView(
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
                                  numberFormat
                                      .format(controller.total_invoice / 100),
                                  style: const TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                            controller.total_invoice != 0
                                ? Column(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Valor por morador",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0 * controller.users.length,
                                        child: ListView(
                                          children: controller.users
                                              .map(
                                                (e) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child: Text(e['name']),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              4, 3, 1, 0),
                                                      child: Text(
                                                        "R\$",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Text(
                                                      numberFormat.format(
                                                          (controller.total_invoice_person -
                                                                  e['paid']) /
                                                              100),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            controller.total_invoice != 0
                                ? const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text(
                                      "Lançamento por Morador",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
                            Wrap(
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
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                width: 120,
                                child: Text(
                                  "${toBeginningOfSentenceCase(e['name'].toString())!} ${(e['total'] * 100).round().toString()}%",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList()),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: SizedBox(
                                width: _width * .8,
                                height: 25,
                                //margin: const EdgeInsets.only(top: 5),
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
                                          width: _width * .8 * (e['total']),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),

                            //category percents
                            controller.total_invoice != 0
                                ? const Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 10),
                                    child: Text(
                                      "Gasto por Categoria",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Container(),
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
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                width: 120,
                                child: Text(
                                  "${toBeginningOfSentenceCase(e['name'].toString())!} ${(e['value'] * 100).round().toString()}%",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList()),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: SizedBox(
                                width: _width * .8,
                                height: 25,
                                //margin: const EdgeInsets.only(top: 5),
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
                            ),
                          ],
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
