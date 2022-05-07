import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:frontend/app/modules/home/widget/showInformationPopup.dart';
import 'package:intl/intl.dart';

Widget InvoicesPage(
    {required BuildContext context, required HomeStore controller}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var numberFormat = NumberFormat('##0.00');


  return Container(
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
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: controller.invoices != null &&
                      !controller.loading &&
                      controller.invoices!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async => await controller.get_invoices(),
                      child: ListView(
                        children: controller.invoices!
                            .map(
                              (e) => GestureDetector(
                                onTap: () async {
                                  await controller.set_select_invoice(e);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ShowInformationPopup(
                                          context: context,
                                          controller: controller);
                                    },
                                  );
                                },
                                child: Container(
                                  height: 65,
                                  //margin: EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                                      e['category']['name']
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
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : controller.invoices != null && controller.invoices!.isEmpty
                      ? RefreshIndicator(
                          onRefresh: () async =>
                              await controller.get_invoices(),
                          child:
                              const Center(child: Text("Ainda não há contas")))
                      : const CircularProgressIndicator(),
            );
          })
        ],
      ),
    ),
  );
}
