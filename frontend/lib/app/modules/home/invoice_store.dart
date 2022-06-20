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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  get_invoices() async {
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

    calc_total();

    loading = false;
  }

  @observable
  Invoice? select_invoice;

  @action
  set_select_invoice(Invoice? I) {
    select_invoice = I;
  }

  @observable
  int? invoice_id;

  @observable
  bool is_modify = false;

  @observable
  bool? is_payed;

  @action
  set_paid(bool? e) {
    is_payed = e;
    print(is_payed);
  }

  @observable
  Category? category;

  @action
  set_category(Category e) {
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
  set_date(DateTime dt) {
    date = dt;
  }

  modify() {
    is_modify = true;
    description.text = select_invoice!.description;
    price!.updateValue(select_invoice!.price / 100);
    date = select_invoice!.date;
    invoice_id = select_invoice!.id;
    is_payed = select_invoice!.paid;
  }

  @action
  clear_input() {
    description.text = "";
    category = null;
    price!.updateValue(0.00);
    date = DateTime.now();
    is_modify = false;
    is_payed = null;
  }

  @action
  add_invoice() async {
    print(add_invoice);
    loading = true;
    try {
      var result = await ConnectionManager.add_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              homeId: home.id,
              isPayed: is_payed)
          .then((value) {
        clear_input();
      });
    } on Exception catch (e) {
      print('add_invoice:  nao conseguiu adicionar invoice');
      print(e);
    }

    loading = false;
  }

  @action
  modify_invoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.modify_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              invoiceId: invoice_id!,
              isPayed: is_payed)
          .then((value) {
        clear_input();
      });
    } on Exception catch (e) {
      print('modify_invoice:  nao conseguiu modificar invoice');
      print(e);
    }

    is_modify = false;
    loading = false;
  }

  @action
  remove_invoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.remove_invoice(
        userId: select_invoice!.user.id,
        invoiceId: select_invoice!.id,
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
  get_categories() async {
    loading = true;
    List<Category> result = await ConnectionManager.get_categories();
    categories = result;
    loading = false;
  }

  @observable
  num total_invoice = 0;

  @observable
  num any_payed = 0;

  @observable
  num total_invoice_person = 0;

  @observable
  List<Map<dynamic, dynamic>> category_percents = [{}];

  @observable
  List<Map<dynamic, dynamic>> users = [{}];

  @action
  calc_total() async {
    total_invoice = 0;
    total_invoice_person = 0;
    any_payed = 0;
    users.clear();
    category_percents = [{}];
    var aux = {};
    var auxCategory = {};

    int? numUsers;
    try {
      var data = await ConnectionManager.number_users(homeId: home.id);

      numUsers = data!.length;

      data.forEach((e) {
        aux[e['users']['userid']] = {
          'value': 0,
          'name': e['users']['name'],
          'paid': 0,
        };
      });
    } on Exception catch (e) {
      print('calc_total:  nao conseguiu obter o numero de users');
      print(e);
    }

    for (var element in invoices) {
      total_invoice += element.price;
      any_payed += element.paid == false ? element.price : 0;
      aux[element.user.id] = {
        'value': aux[element.user.id]['value']! + element.price,
        'name': element.user.name,
        'paid': element.paid == true
            ? aux[element.user.id]['paid']! + element.price
            : aux[element.user.id]['paid']!,
      };

      auxCategory[element.category.name] =
          auxCategory[element.category.name] == null
              ? {'value': element.price, 'name': element.category.name}
              : {
                  'value': auxCategory[element.category.name]['value']! +
                      element.price,
                  'name': element.category.name
                };
    }

    if (((total_invoice / numUsers!) - (any_payed / numUsers)) % numUsers ==
        0) {
      total_invoice_person =
          ((total_invoice / numUsers) - (any_payed / numUsers)).toInt();
    } else {
      total_invoice_person =
          ((total_invoice / numUsers) - (any_payed / numUsers) + 1).toInt();
    }

    if (total_invoice == 0) return;

    aux.forEach((id, value) {
      users.add({
        'id': id,
        'total': ((((value['value'] * 100) / total_invoice)) / 100),
        'r': Random().nextInt(255),
        'g': Random().nextInt(255),
        'b': Random().nextInt(255),
        'name': value['name'],
        'paid': value['paid'],
      });
    });

    auxCategory.forEach((id, value) {
      category_percents.add({
        'value': ((((value['value'] * 100) / total_invoice)) / 100),
        'name': value['name'],
        'r': Random().nextInt(255),
        'g': Random().nextInt(255),
        'b': Random().nextInt(255),
      });
    });
    category_percents.removeAt(0);

    print("User: ${users}");
  }
}
