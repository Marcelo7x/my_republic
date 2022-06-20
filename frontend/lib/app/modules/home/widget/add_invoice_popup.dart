import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/select_date_popup.dart';
import 'package:frontend/domain/category.dart';
import 'package:intl/intl.dart';

Widget AddInvoicePopup(
    {required BuildContext context, required HomeStore controller, required InvoiceStore invoices_controller}) {
  return AlertDialog(
    title: !invoices_controller.is_modify
        ? const Text("Adicionar Gasto")
        : const Text("Modificar Gasto"),
    contentPadding: const EdgeInsets.all(10),
    actionsPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    content: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Observer(builder: (_) {
                return DropdownButton(
                  borderRadius: BorderRadius.circular(18),
                  hint: const Text("Selecione uma categoria"),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: invoices_controller.category,
                  items: invoices_controller.categories.map((Category e) {
                    return DropdownMenuItem<Category>(
                      value: e,
                      child: Text(toBeginningOfSentenceCase(e.name)!),
                    );
                  }).toList(),
                  onChanged: (Category? e) {
                    invoices_controller.set_category(e!);
                  },
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Selecione o dia: "),
                  GestureDetector(
                    child: Row(
                      children: [
                        Observer(builder: (_) {
                          return Text(
                            "${invoices_controller.date.day}/${invoices_controller.date.month}/${invoices_controller.date.year}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(Icons.calendar_month,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SelectDatePopup(
                            context: context, invoices_controller: invoices_controller);
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                  controller: invoices_controller.description,
                  maxLines: 2,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    label: Text("Adicione uma descrição"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )),
              TextField(
                  controller: invoices_controller.price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text("Digite o valor"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )),
              Observer(builder: (_) {
                return DropdownButton<bool?>(
                  borderRadius: BorderRadius.circular(18),
                  hint: invoices_controller.is_payed == null
                      ? const Text("Em aberto")
                      : invoices_controller.is_payed == false
                          ? const Text("Pago por mim")
                          : Text(
                              "pago por todos",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: invoices_controller.is_payed,
                  items: const [
                    DropdownMenuItem<bool?>(
                      value: null,
                      child: Text("Em aberto"),
                    ),
                    DropdownMenuItem<bool?>(
                      value: true,
                      child: Text("Pago por mim"),
                    ),
                    DropdownMenuItem<bool?>(
                      value: false,
                      child: Text("Pago por todos"),
                    ),
                  ],
                  onChanged: (bool? e) {
                    invoices_controller.set_paid(e);
                  },
                );
              }),
            ]),
      ),
    ),
    actions: <Widget>[
      // define os botões na base do dialogo
      ElevatedButton(
        child: const Text("Adicionar"),
        onPressed: () async {
          if (invoices_controller.description.text == "" ||
              invoices_controller.category == null ||
              invoices_controller.price!.value == 0.00) {
            return;
          }
          print('jklashd');

          !invoices_controller.is_modify
              ? await invoices_controller.add_invoice()
              : await invoices_controller.modify_invoice();

          Navigator.of(context).pop();
          invoices_controller.get_invoices();
          Modular.to.navigate('/home/');
        },
      ),
      TextButton(
        child: Text(
          "Cancelar",
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        onPressed: () {
          invoices_controller.clear_input();
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
