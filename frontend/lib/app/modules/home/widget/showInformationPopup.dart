import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/addInvoicePopup.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget ShowInformationPopup(
    {required BuildContext context, required HomeStore controller}) {
  var numberFormat = NumberFormat('##0.00');
  var e = controller.select_invoice;

  return Container(child: Observer(builder: (_) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 3, top: 7),
                      child: Text(
                        "R\$",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      "${(numberFormat.format(int.parse(e['invoice']['price']) / 100))}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  left: 5,
                )),
                Text(
                  "${e['invoice']['date'].day}/${e['invoice']['date'].month}/${e['invoice']['date'].year}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Categoria",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          e['category']['name'].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Usuário",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          e['users']['name'].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Column(
              children: [
                const Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  e['invoice']['description'].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        e['invoice']['userid'] == controller.id
            ? ElevatedButton(
                onPressed: () async {
                  controller.modify(e);

                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddInvoicePopup(
                            context: context, controller: controller);
                      });

                  Modular.to.pop();
                },
                child: Row(
                  children: const [
                    Icon(Icons.edit_road),
                    Text("Editar"),
                  ],
                ),
              )
            : Container(),
        e['invoice']['userid'] == controller.id
            ? ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // retorna um objeto do tipo Dialog
                        return AlertDialog(
                          title: const Text(
                              "Tem certeza que deseja excluir essa conta?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                await controller.remove_invoice(
                                    user_id: e['invoice']['userid'],
                                    invoice_id: e['invoice']['invoiceid']);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                await controller.get_invoices();
                              },
                              child: const Text("Sim"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancelar"),
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: const [
                    Icon(Icons.delete),
                    Text("Excluir"),
                  ],
                ),
              )
            : Container(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Fechar"),
        ),
      ],
    );
  }));
}
