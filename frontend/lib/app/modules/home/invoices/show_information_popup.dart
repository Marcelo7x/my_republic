import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/add_invoice_popup.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget ShowInformationPopup(
    {required BuildContext context,
    required HomeStore homeController,
    required InvoiceStore invoicesController}) {
  var numberFormat = NumberFormat('##0.00');
  var e = invoicesController.selectedInvoice;

  return Observer(builder: (_) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 12),
                          child: Text(
                            "R\$",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          (numberFormat.format(e!.price / 100)),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 12),
                      child: Text(
                        "${e.date.day}/${e.date.month}/${e.date.year}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(children: [
                const Text(
                  "Usuário: ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  toBeginningOfSentenceCase(e.user.name.toString())!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
              e.paid != null
                  ? Row(children: [
                      const Text(
                        "Pago por: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        e.paid == true
                            ? toBeginningOfSentenceCase(e.user.name.toString())!
                            : 'Todos',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ])
                  : Container(),
              Row(
                children: [
                  const Text(
                    "Categoria: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    toBeginningOfSentenceCase(e.category.name.toString())!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Descrição: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    toBeginningOfSentenceCase(e.description.toString())!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  e.user.id == homeController.user.id
                      ? SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              invoicesController.modify();

                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AddInvoicePopup();
                                  });
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.edit_road),
                                Text("Editar"),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  e.user.id == homeController.user.id
                      ? SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // retorna um objeto do tipo Dialog
                                    return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      content: const Text(
                                          "Tem certeza que deseja excluir essa conta?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            await invoicesController
                                                .removeInvoice();

                                            Navigator.of(context).pop();

                                            await homeController.reload();
                                          },
                                          child: const Text("Sim"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                Text(
                                  "Excluir",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              TextButton(
                onPressed: () {
                  invoicesController.selectInvoice(null);
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ],
      ),
    );
  });
}
