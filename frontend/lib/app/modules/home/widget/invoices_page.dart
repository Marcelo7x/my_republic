import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:frontend/app/modules/home/widget/show_information_popup.dart';
import 'package:intl/intl.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  Widget build(BuildContext context) {
    final HomeStore homeController = Modular.get<HomeStore>();
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var numberFormat = NumberFormat('##0.00');

    return SafeArea(
      child: Column(
        children: [
          Container(
            //header
            height: height * 0.1,
            width: width * 0.9,
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
                SelectDateInterval(context, homeController, invoicesController)
              ],
            ),
          ),
          Observer(builder: (_) {
            return Card(
              child: Container(
                height: height * .75,
                width: width * .95,
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child:
                    !invoicesController.loading &&
                            invoicesController.invoices.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async =>
                                await invoicesController.getInvoices(),
                            child: Observer(
                                builder: (_) => ListView(
                                      children: invoicesController.invoices
                                          .map(
                                            (e) => GestureDetector(
                                              onTap: () async {
                                                invoicesController
                                                            .selectedInvoice !=
                                                        e
                                                    ? await invoicesController
                                                        .selectInvoice(e)
                                                    : await invoicesController
                                                        .selectInvoice(null);
                                              },
                                              child: AnimatedSize(
                                                alignment: Alignment.topCenter,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.fastOutSlowIn,
                                                child: Card(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child:
                                                        Observer(builder: (_) {
                                                      return SizedBox(
                                                        height: invoicesController
                                                                    .selectedInvoice !=
                                                                e
                                                            ? 60
                                                            : height * .4,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            invoicesController
                                                                        .selectedInvoice !=
                                                                    e
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  toBeginningOfSentenceCase(e.category.name.toString())!,
                                                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                const Padding(padding: EdgeInsets.only(left: 5)),
                                                                                Text(
                                                                                  "${e.date.day}/${e.date.month}",
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              toBeginningOfSentenceCase(e.user.name.toString())!,
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 5, top: 7),
                                                                            child:
                                                                                Text(
                                                                              "R\$",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            (numberFormat.format(e.price /
                                                                                100)),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 28,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          e.paid == true
                                                                              ? Container(
                                                                                  width: 54,
                                                                                  height: 20,
                                                                                  margin: const EdgeInsets.only(bottom: 20, left: 10),
                                                                                  child: Row(
                                                                                    children: const [
                                                                                      Icon(Icons.person),
                                                                                      Icon(Icons.monetization_on_rounded, color: Colors.green)
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : e.paid == false
                                                                                  ? Container(
                                                                                      width: 54,
                                                                                      height: 20,
                                                                                      margin: const EdgeInsets.only(bottom: 20, left: 10),
                                                                                      child: Row(children: const [
                                                                                        Icon(Icons.group),
                                                                                        Icon(Icons.monetization_on_rounded, color: Colors.green)
                                                                                      ]),
                                                                                    )
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                            invoicesController
                                                                        .selectedInvoice ==
                                                                    e
                                                                ? ShowInformationPopup(
                                                                    context:
                                                                        context,
                                                                    homeController:
                                                                        homeController,
                                                                    invoicesController:
                                                                        invoicesController)
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
                                    )),
                          )
                        : invoicesController.invoices.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async =>
                                    await homeController.reload(),
                                child: const Center(
                                    child: Text("Ainda não há contas")))
                            : const CircularProgressIndicator(),
              ),
            );
          })
        ],
      ),
    );
  }
}
