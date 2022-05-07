import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectDate.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddInvoicePopup extends StatefulWidget {
  const AddInvoicePopup({ Key? key }) : super(key: key);

  @override
  State<AddInvoicePopup> createState() => _AddInvoicePopupState();
}

class _AddInvoicePopupState extends ModularState<AddInvoicePopup, HomeStore> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: !controller.is_modify
                ? const Text("Adicionar Gasto")
                : const Text("Modificar Gasto"),
            contentPadding: const EdgeInsets.all(10),
            actionsPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * .4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                          controller: controller.category,
                          decoration: const InputDecoration(
                            label: Text("Adicione uma categoria"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          )),
                      TextField(
                          controller: controller.description,
                          decoration: const InputDecoration(
                            label: Text("Adicione uma descrição"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          )),
                      Row(
                        children: [
                          const Text("Selecione o dia: "),
                          GestureDetector(
                            child: Row(
                              children: [
                                Observer(builder: (_) {
                                  return Text(
                                    "${controller.date.day}/${controller.date.month}/${controller.date.year}",
                                    style: const TextStyle(
                                        color: Colors.blueAccent),
                                  );
                                }),
                                const Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: Icon(Icons.calendar_month,
                                      color: Colors.blueAccent),
                                )
                              ],
                            ),
                            onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SelectData();
                              },
                            ),
                          ),
                        ],
                      ),
                      TextField(
                          controller: controller.price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Digite o valor"),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                          )),
                    ]),
              ),
            ),
            actions: <Widget>[
              // define os botões na base do dialogo
              ElevatedButton(
                child: Text("Adicionar"),
                onPressed: () async {
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}