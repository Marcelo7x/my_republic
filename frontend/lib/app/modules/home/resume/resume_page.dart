import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_page.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/invoices/show_information_popup.dart';
import 'package:frontend/app/modules/home/resume/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';
import 'package:frontend/domain/enum_paid.dart';
import 'package:intl/intl.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({Key? key}) : super(key: key);

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  Widget build(BuildContext context) {
    final HomeStore homeController = Modular.get<HomeStore>();
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    final BalanceStore balanceController = Modular.get<BalanceStore>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var numberFormat = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'R\$',
    );

    List<String> months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //header
              height: height * 0.05,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Text(
                    "Contas do Mês",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 1),
                  child: Text(
                    "Total a pagar ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Observer(
                  builder: (_) {
                    num total = balanceController.totalInvoicePerson -
                        (balanceController.residents[balanceController.user.id]
                                ?['paid'] ??
                            0);
                    return Text(
                      numberFormat.format(total / 100),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  },
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Modular.to.push(
                    MaterialPageRoute(builder: ((context) => BalancePage())));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.8,
                      height: 50,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.graphic_eq,
                            size: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Balanço",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Veja um resumo das contas de ${homeController.home.id}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 50,
                ),
                child: SizedBox(
                  height: 120,
                  width: width,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Modular.to.push(MaterialPageRoute(
                              builder: ((context) => AddInvoicePopup())));
                        },
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
                                ),
                                child: const Icon(
                                  Icons.post_add,
                                  size: 30,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Adicionar",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  softWrap: false,
                                  maxLines: 2,
                                ),
                              ),
                              const Text(
                                "conta",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                softWrap: false,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withAlpha(150),
              height: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, bottom: 20),
              child: Text(
                "Histórico do mês",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Observer(builder: (_) {
              return SizedBox(
                height: 100.0 * invoicesController.invoices.length,
                width: width,
                child: Observer(builder: (_) {
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    children: invoicesController.invoices
                        .map(
                          (e) => Container(
                            height: 100,
                            width: width,
                            padding: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant
                                      .withAlpha(150),
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.difference_outlined,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            toBeginningOfSentenceCase(
                                                e.category.name)!,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            e.user.name
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            numberFormat.format(e.price),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    "${e.date.day} ${months[e.date.month]}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
