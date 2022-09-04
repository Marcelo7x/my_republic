import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:intl/intl.dart';

Widget BalancePage(
    {required BuildContext context, required InvoiceStore invoicesController}) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  var numberFormat = NumberFormat('##0.00');
  final BalanceStore balanceController = Modular.get<BalanceStore>();
  final HomeStore homeController = Modular.get<HomeStore>();

  return SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            //header
            height: height * 0.1,
            width: width * 0.9,
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
                SelectDateInterval(
                    context, Modular.get<HomeStore>(), invoicesController)
              ],
            ),
          ),
          Observer(builder: (_) {
            return Card(
              child: Container(
                height: height * .75,
                width: width * .95,
                padding: const EdgeInsets.all(10),
                child: invoicesController.invoices.isEmpty
                    ? RefreshIndicator(
                        onRefresh: () async =>
                            await homeController.reload(),
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
                                Observer(builder: (_) {
                                  return Text(
                                    numberFormat.format(
                                        balanceController.totalInvoice / 100),
                                    style: const TextStyle(
                                      fontSize: 28,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            balanceController.totalInvoice != 0
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
                                        height: 30.0 *
                                            balanceController.residents.length,
                                        child: ListView(
                                          children: balanceController
                                              .residents.entries
                                              .map(
                                                (e) => Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 3),
                                                      child:
                                                          Text(e.value['name']),
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
                                                          (balanceController
                                                                      .totalInvoicePerson -
                                                                  e.value[
                                                                      'paid']) /
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
                            balanceController.totalInvoice != 0
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
                                children: balanceController.residents.entries
                                    .map((e) {
                              return Container(
                                height: 30,
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(
                                      255,
                                      e.value['r'],
                                      e.value['g'],
                                      e.value['b'],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                width: 120,
                                child: Text(
                                  "${toBeginningOfSentenceCase(e.value['name'].toString())!} ${(e.value['total'] * 100).round().toString()}%",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList()),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: SizedBox(
                                width: width * .8,
                                height: 25,
                                //margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: balanceController.residents.entries
                                      .map(
                                        (e) => Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              255,
                                              e.value['r'],
                                              e.value['g'],
                                              e.value['b'],
                                            ),
                                          ),
                                          width:
                                              width * .8 * (e.value['total']),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),

                            //category percents
                            balanceController.totalInvoice != 0
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
                                children: balanceController
                                    .categoryPercents.entries
                                    .map((e) {
                              return Container(
                                height: 30,
                                width: 150,
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(
                                      255,
                                      e.value['r'],
                                      e.value['g'],
                                      e.value['b'],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  "${toBeginningOfSentenceCase(e.value['name'].toString())!} ${(e.value['value'] * 100).round().toString()}%",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList()),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: SizedBox(
                                width: width * .8,
                                height: 25,
                                //margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: balanceController
                                      .categoryPercents.entries
                                      .map(
                                        (e) => Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              255,
                                              e.value['r'],
                                              e.value['g'],
                                              e.value['b'],
                                            ),
                                          ),
                                          width:
                                              width * .8 * (e.value['value']),
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
