import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/widget/select_date_popup.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/enum_paid.dart';
import 'package:intl/intl.dart';

class AddInvoicePopup extends StatefulWidget {
  const AddInvoicePopup({Key? key}) : super(key: key);

  @override
  State<AddInvoicePopup> createState() => _AddInvoicePopupState();
}

class _AddInvoicePopupState extends State<AddInvoicePopup> {
  @override
  Widget build(BuildContext context) {
    final InvoiceStore invoicesController = Modular.get<InvoiceStore>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      Icons.arrow_back_ios_new_rounded,
                      size: 25,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.post_add_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        !invoicesController.isModify
                            ? " Adicionar Conta"
                            : " Modificar Conta",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .68,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Observer(
                          builder: (_) {
                            return DropdownButton(
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              borderRadius: BorderRadius.circular(18),
                              hint: const Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Text(
                                  "Selecione uma categoria",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              underline: Container(
                                height: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              value: invoicesController.category,
                              items: invoicesController.categories
                                  .map((Category e) {
                                return DropdownMenuItem<Category>(
                                  value: e,
                                  child:
                                      Text(toBeginningOfSentenceCase(e.name)!),
                                );
                              }).toList(),
                              onChanged: (Category? e) {
                                invoicesController.setCategory(e!);
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Selecione o dia: ",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Observer(builder: (_) {
                                    return Text(
                                      "${invoicesController.date.day}/${invoicesController.date.month}/${invoicesController.date.year}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    );
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Icon(Icons.calendar_month,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  )
                                ],
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectDatePopup(
                                      context: context,
                                      invoicesController: invoicesController);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "Descrição",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          controller: invoicesController.description,
                          decoration: const InputDecoration(
                            hintText: "...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "Valor",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          controller: invoicesController.price,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 20),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Situação",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: SizedBox(
                          height: 120,
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  invoicesController.setPaid(Paid.unpaid);
                                },
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Column(
                                    children: [
                                      Observer(
                                        builder: (_) {
                                          return Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color:
                                                  invoicesController.isPayed ==
                                                          Paid.unpaid
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surfaceVariant,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Observer(builder: (_) {
                                              return Icon(
                                                Icons.attach_money_rounded,
                                                size: 30,
                                                color: invoicesController
                                                            .isPayed ==
                                                        Paid.unpaid
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Em aberto",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          softWrap: false,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  invoicesController.setPaid(Paid.payed);
                                },
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Column(
                                    children: [
                                      Observer(
                                        builder: (_) {
                                          return Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color:
                                                  invoicesController.isPayed ==
                                                          Paid.payed
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surfaceVariant,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Observer(
                                              builder: (_) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 30,
                                                  color: invoicesController
                                                              .isPayed ==
                                                          Paid.payed
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Pago por mim",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          softWrap: false,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  invoicesController.setPaid(Paid.anypayed);
                                },
                                child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Column(
                                    children: [
                                      Observer(builder: (_) {
                                        return Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: invoicesController.isPayed ==
                                                    Paid.anypayed
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surfaceVariant,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Observer(builder: (_) {
                                            return Icon(
                                              Icons.groups,
                                              size: 30,
                                              color:
                                                  invoicesController.isPayed ==
                                                          Paid.anypayed
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                            );
                                          }),
                                        );
                                      }),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Pago por todos",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          softWrap: false,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
            Observer(builder: (_) {
              return Container(
                width: width,
                height: 60,
                color: Theme.of(context).colorScheme.primary,
                child: TextButton(
                  child: Observer(builder: (_) {
                    return Text(
                      invoicesController.isModify ? "Atualizar" : "Adicionar",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    );
                  }),
                  onPressed: () async {
                    if (invoicesController.category == null ||
                        invoicesController.price!.numberValue <= 0.00) {
                      return;
                    }

                    bool closeIfIsModify = invoicesController.isModify;

                    !invoicesController.isModify
                        ? await invoicesController.addInvoice()
                        : await invoicesController.modifyInvoice();

                    Navigator.of(context).pop();
                    if (closeIfIsModify) {
                      Navigator.of(context).pop();
                    }
                    Modular.to.navigate('/home/');
                    await Modular.get<HomeStore>().reload();
                  },
                ),
              );
            }),
            Container(
              width: width,
              height: 60,
              color: Theme.of(context).colorScheme.errorContainer,
              child: TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  invoicesController.clearInput();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
