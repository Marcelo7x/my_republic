import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:frontend/app/modules/home/widget/show_information_popup.dart';
import 'package:intl/intl.dart';

Widget InvoicesPage(
    {required BuildContext context, required HomeStore controller}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var numberFormat = NumberFormat('##0.00');

  bool size = false;

  return Container(
    child: SafeArea(
      child: Column(
        children: [
          Container(
            //header
            height: _height * 0.1,
            width: _width * 0.9,
            decoration: BoxDecoration(
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
                      "Contas do Mês",
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
                        padding: EdgeInsets.only(left: 8.0),
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
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: !controller.loading && controller.invoices.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: () async => await controller.get_invoices(),
                        child: ListView(
                          children: controller.invoices
                              .map(
                                (e) => GestureDetector(
                                  onTap: () async {
                                    controller.select_invoice != e
                                        ? await controller.set_select_invoice(e)
                                        : await controller
                                            .set_select_invoice(null);
                                  },
                                  child: AnimatedSize(
                                    alignment: Alignment.topCenter,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Observer(builder: (_) {
                                          return SizedBox(
                                            height:
                                                controller.select_invoice != e
                                                    ? 60
                                                    : _height * .4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                controller.select_invoice != e
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            height: 50,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      toBeginningOfSentenceCase(e
                                                                          .category
                                                                          .name
                                                                          .toString())!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 5)),
                                                                    Text(
                                                                      "${e.date.day}/${e.date.month}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  toBeginningOfSentenceCase(e
                                                                      .user.name
                                                                      .toString())!,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            5,
                                                                        top: 7),
                                                                child: Text(
                                                                  "R\$",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                (numberFormat
                                                                    .format(
                                                                        e.price /
                                                                            100)),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 28,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              e.paid == true
                                                                  ? Container(
                                                                      width: 54,
                                                                      height:
                                                                          20,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              20,
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        children: const [
                                                                          Icon(Icons
                                                                              .person),
                                                                          Icon(
                                                                              Icons.monetization_on_rounded,
                                                                              color: Colors.green)
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : e.paid ==
                                                                          false
                                                                      ? Container(
                                                                          width:
                                                                              54,
                                                                          height:
                                                                              20,
                                                                          margin: const EdgeInsets.only(
                                                                              bottom: 20,
                                                                              left: 10),
                                                                          child:
                                                                              Row(children: const [
                                                                            Icon(Icons.group),
                                                                            Icon(Icons.monetization_on_rounded,
                                                                                color: Colors.green)
                                                                          ]),
                                                                        )
                                                                      : Container(),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                controller.select_invoice == e
                                                    ? ShowInformationPopup(
                                                        context: context,
                                                        controller: controller)
                                                    : Container(),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : controller.invoices.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async =>
                                await controller.get_invoices(),
                            child: const Center(
                                child: Text("Ainda não há contas")))
                        : const CircularProgressIndicator(),
              ),
            );
          })
        ],
      ),
    ),
  );
}
