import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/resume/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/domain/enum_paid.dart';
import 'package:intl/intl.dart';

Widget ShowInformationPopup(
    {required BuildContext context,
    required HomeStore homeController,
    required InvoiceStore invoicesController}) {
  var e = invoicesController.selectedInvoice;
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

  return Observer(builder: (_) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10)),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
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
                              Icons.close_rounded,
                              size: 25,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(
                              "${e!.date.day} ${months[e.date.month - 1]} ${e.date.year}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: e.paid == Paid.payed || e.paid == Paid.anypayed
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.post_add,
                    size: 30,
                    color: e.paid == Paid.payed || e.paid == Paid.anypayed
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    e.category.name.toString().toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  child: Text(
                    toBeginningOfSentenceCase(e.user.name)!,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(150),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    e.paid == Paid.payed
                        ? "Pago por ${e.user.name}"
                        : e.paid == Paid.anypayed
                            ? "Pago por todos"
                            : "Em aberto",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Observer(
                    builder: (_) {
                      return Text(
                        numberFormat.format(e.price / 100),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: height * .2,
                  width: width * .8,
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.surfaceVariant),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Descrição: ' + e.description,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            homeController.user.id == e.user.id
                ? Observer(
                    builder: (_) {
                      return Container(
                        width: width,
                        height: 60,
                        color: Theme.of(context).colorScheme.primary,
                        child: TextButton(
                          child: Observer(builder: (_) {
                            return Text(
                              "Editar",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            );
                          }),
                          onPressed: () async {
                            invoicesController.modify();
                            Modular.to.push(MaterialPageRoute(
                                builder: ((context) => AddInvoicePopup())));
                          },
                        ),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  });
}
