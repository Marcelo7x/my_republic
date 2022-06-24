import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/invoice.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';

part 'invoice_store.g.dart';

class InvoiceStore = InvoiceStoreBase with _$InvoiceStore;

abstract class InvoiceStoreBase with Store {
  User user = Modular.args.data['user'];
  Home home = Modular.args.data['home'];

  @observable
  bool loading = false;

  @observable
  List<Invoice> invoices = [];

  @action
  getInvoices() async {
    final dateRange = Modular.get<HomeStore>().dateRange;
    if (dateRange.startDate == null || dateRange.endDate == null) {
      return;
    }

    loading = true;

    var result = await ConnectionManager.get_invoices(
        start_date: dateRange.startDate!,
        end_date: dateRange.endDate!,
        home_id: home.id);

    invoices.clear();

    for (var e in result) {
      User u = User(e['invoice']['userid'], e['users']['name']);
      invoices.add(Invoice(
          id: e['invoice']['invoiceid'],
          user: u,
          home: home,
          category: Category(
              id: e['invoice']['categoryId'], name: e['category']['name']),
          price: int.parse(e['invoice']['price']),
          description: e['invoice']['description'],
          date: DateTime.parse(e['invoice']['date']),
          paid: e['invoice']['paid']));
    }

    calcTotal();

    loading = false;
  }

  @observable
  Invoice? selectedInvoice;

  @action
  selectInvoice(Invoice? I) {
    selectedInvoice = I;
  }

  @observable
  int? invoiceId;

  @observable
  bool isModify = false;

  @observable
  bool? isPayed;

  @action
  setPaid(bool? e) {
    isPayed = e;
    print(isPayed);
  }

  @observable
  Category? category;

  @action
  setCategory(Category e) {
    category = e;
  }

  @observable
  TextEditingController description = TextEditingController();

  @observable
  MoneyMaskedTextController? price = MoneyMaskedTextController(
      leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');

  @observable
  DateTime date = DateTime.now();

  @action
  setDate(DateTime dt) {
    date = dt;
  }

  modify() {
    isModify = true;
    description.text = selectedInvoice!.description;
    price!.updateValue(selectedInvoice!.price / 100);
    date = selectedInvoice!.date;
    invoiceId = selectedInvoice!.id;
    isPayed = selectedInvoice!.paid;
  }

  @action
  clearInput() {
    description.text = "";
    category = null;
    price!.updateValue(0.00);
    date = DateTime.now();
    isModify = false;
    isPayed = null;
  }

  @action
  addInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.add_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              homeId: home.id,
              isPayed: isPayed)
          .then((value) {
        clearInput();
      });
    } on Exception catch (e) {
      print('add_invoice:  nao conseguiu adicionar invoice');
      print(e);
    }

    loading = false;
  }

  @action
  modifyInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.modify_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              invoiceId: invoiceId!,
              isPayed: isPayed)
          .then((value) {
        clearInput();
      });
    } on Exception catch (e) {
      print('modify_invoice:  nao conseguiu modificar invoice');
      print(e);
    }

    isModify = false;
    loading = false;
  }

  @action
  removeInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.remove_invoice(
        userId: selectedInvoice!.user.id,
        invoiceId: selectedInvoice!.id,
      );
    } on Exception catch (e) {
      print('remove_invoice:  nao conseguiu remover invoice');
      print(e);
    }

    loading = false;
  }

  @observable
  List<Category> categories = [];

  @action
  getCategories() async {
    loading = true;
    List<Category> result = await ConnectionManager.get_categories();
    categories = result;
    loading = false;
  }

  @observable
  num totalInvoice = 0;

  @observable
  num anyPayed = 0;

  @observable
  num totalInvoicePerson = 0;

  @observable
  Map<String, dynamic> categoryPercents = {};

  @observable
  Map<int, dynamic> residents = {};

  @action
  getResidents() async {
    try {
      var data = await ConnectionManager.number_users(homeId: home.id);

      data.forEach((e) {
        residents[e['users']['userid']] = {
          'value': 0,
          'name': e['users']['name'],
          'total': 0,
          'paid': 0,
          'r': Random().nextInt(255),
          'g': Random().nextInt(255),
          'b': Random().nextInt(255),
        };
      });
    } on Exception catch (e) {
      print('calc_total:  nao conseguiu obter o numero de users');
      print(e);
    }
  }

  @action
  calcTotal() async {
    totalInvoice = 0;
    totalInvoicePerson = 0;
    anyPayed = 0;
    categoryPercents = {};
    var aux = {};
    var auxCategory = {};

    await getResidents();

    for (var element in invoices) {
      totalInvoice += element.price;
      anyPayed += element.paid == false ? element.price : 0;
      residents[element.user.id]['value'] += element.price;
      residents[element.user.id]['paid'] = element.paid == true
          ? residents[element.user.id]['paid']! + element.price
          : residents[element.user.id]['paid']!;

      if (categoryPercents[element.category.name] == null) {
        categoryPercents[element.category.name] = {
          'name': element.category.name,
          'value': element.price,
          'r': Random().nextInt(255),
          'g': Random().nextInt(255),
          'b': Random().nextInt(255),
        };
      } else {
        categoryPercents[element.category.name]['value'] += element.price;
      }
    }

    if (((totalInvoice / residents.length) - (anyPayed / residents.length)) %
            residents.length ==
        0) {
      totalInvoicePerson =
          ((totalInvoice / residents.length) - (anyPayed / residents.length))
              .toInt();
    } else {
      totalInvoicePerson = ((totalInvoice / residents.length) -
              (anyPayed / residents.length) +
              1)
          .toInt();
    }

    if (totalInvoice == 0) return;

    residents.forEach((id, value) {
      residents[id]['total'] =
          ((((value['value'] * 100) / totalInvoice)) / 100);
    });

    categoryPercents.forEach((name, value) {
      categoryPercents[name]['value'] =
          ((((value['value'] * 100) / totalInvoice)) / 100);
    });
  }
}
