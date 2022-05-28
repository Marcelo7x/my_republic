import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/select_date_popup.dart';
import 'package:frontend/domain/category.dart';
import 'package:intl/intl.dart';

Widget AddInvoicePopup(
    {required BuildContext context, required HomeStore controller}) {
  
  return AlertDialog(
    title: !controller.is_modify
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
                  value: controller.category,
                  items: controller.categories.map((Category e) {
                    return DropdownMenuItem<Category>(
                      value: e,
                      child: Text(toBeginningOfSentenceCase(
                          e.name)!),
                    );
                  }).toList(),
                  onChanged: (Category? e) {
                    controller.set_category(e!);
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
                            "${controller.date.day}/${controller.date.month}/${controller.date.year}",
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
                            context: context, controller: controller);
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                  controller: controller.description,
                  maxLines: 2,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    label: Text("Adicione uma descrição"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )),
              TextField(
                  controller: controller.price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text("Digite o valor"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )),
              Observer(builder: (_) {
                return DropdownButton<bool?>(
                  borderRadius: BorderRadius.circular(18),
                  hint: controller.is_payed == null
                      ? Text("Em aberto")
                      : controller.is_payed == false
                          ? Text("Pago por mim")
                          : Text(
                              "pago por todos",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: controller.is_payed,
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
                    controller.set_paid(e);
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
          if(controller.description.text == "" ||
          controller.category == null ||
          controller.price!.value == 0.00 ||
          controller.is_payed == null) {
            return;
          }

          !controller.is_modify
              ? await controller.add_invoice()
              : await controller.modify_invoice();

          Navigator.of(context).pop();
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
          controller.clear_input();
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
