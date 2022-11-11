import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:intl/intl.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final BalanceStore balanceController = Modular.get<BalanceStore>();
    final HomeStore homeController = Modular.get<HomeStore>();
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    var numberFormat = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'R\$',
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //header
                height: height * 0.05,
                width: width,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        invoicesController.clearInput();
                        Modular.to.pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 25,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.graphic_eq,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Text(
                          "Balanço",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15),
                child: Text(
                  "Total do mês",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Observer(
                  builder: (_) {
                    return Text(
                      numberFormat.format(balanceController.totalInvoice / 100),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 15),
                child: Text(
                  "Valor por morador",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: width,
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: balanceController.residents.entries
                      .map(
                        (e) => SizedBox(
                          height: 120,
                          width: 120,
                          child: SizedBox(
                            height: 120,
                            width: 80,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Color.fromARGB(
                                        255,
                                        e.value['r'],
                                        e.value['g'],
                                        e.value['b'],
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${e.value['name']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    softWrap: false,
                                    maxLines: 2,
                                  ),
                                ),
                                Text(
                                  numberFormat.format(
                                      (balanceController.totalInvoicePerson -
                                              e.value['paid']) /
                                          100),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  softWrap: false,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 15),
                child: Text(
                  "Gasto por Categoria",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 5, right: 5),
              //   child: Wrap(
              //       //mainAxisAlignment: MainAxisAlignment.center,
              //       children:
              //           balanceController.categoryPercents.entries.map((e) {
              //     return Container(
              //       height: 30,
              //       width: 150,
              //       margin: const EdgeInsets.all(10),
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Color.fromARGB(
              //             255,
              //             e.value['r'],
              //             e.value['g'],
              //             e.value['b'],
              //           ),
              //         ),
              //         borderRadius: BorderRadius.circular(18),
              //       ),
              //       child: Text(
              //         "${toBeginningOfSentenceCase(e.value['name'].toString())!} ${(e.value['value'] * 100).round().toString()}%",
              //         style: const TextStyle(
              //           fontSize: 14,
              //         ),
              //       ),
              //     );
              //   }).toList()),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(15),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(18),
              //     child: SizedBox(
              //       width: width - 30,
              //       height: 30,
              //       //margin: const EdgeInsets.only(top: 5),
              //       child: Row(
              //         children: balanceController.categoryPercents.entries
              //             .map(
              //               (e) => Container(
              //                 height: 30,
              //                 decoration: BoxDecoration(
              //                   color: Color.fromARGB(
              //                     255,
              //                     e.value['r'],
              //                     e.value['g'],
              //                     e.value['b'],
              //                   ),
              //                 ),
              //                 width: (width - 30) * (e.value['value']),
              //               ),
              //             )
              //             .toList(),
              //       ),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Wrap(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        balanceController.categoryPercents.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Indicator(
                      text: e.value['name'],
                      isSquare: false,
                      color: Color.fromARGB(
                        255,
                        e.value['r'],
                        e.value['g'],
                        e.value['b'],
                      ),
                    ),
                  );
                }).toList()),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 200,
                width: width,
                child: PieChart(
                  PieChartData(
                      sections: balanceController.categoryPercents.entries
                          .map(
                            (e) => PieChartSectionData(
                              value: e.value["value"] * 100,
                              title: "${(e.value["value"] * 100).round()}%",
                              showTitle: true,
                              color: Color.fromARGB(255, e.value["r"],
                                  e.value["g"], e.value["b"]),
                            ),
                          )
                          .toList()),
                  swapAnimationDuration:
                      Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
