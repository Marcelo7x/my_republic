import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/invoice.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  User user = Modular.args.data['user'];
  Home home = Modular.args.data['home'];

  @observable
  int selectedIndex = 0;

  @observable
  var page_controller = PageController();

  @observable
  List<Invoice> invoices = [];

  @observable
  Invoice? select_invoice;

  @observable
  List<Category> categories = [];

  @observable
  int? invoice_id;

  @observable
  bool is_modify = false;

  @observable
  List<Map<dynamic, dynamic>> users = [{}];

  @observable
  List<Map<dynamic, dynamic>> category_percents = [{}];

  @observable
  num total_invoice = 0;

  @observable
  num any_payed = 0;

  @observable
  num total_invoice_person = 0;

  @observable
  PickerDateRange dateRange = PickerDateRange(
      DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 20),
      DateTime.utc(DateTime.now().year, DateTime.now().month, 20));

  @observable
  Category? category;

  @observable
  bool? is_payed;

  @observable
  TextEditingController description = TextEditingController();

  @observable
  MoneyMaskedTextController? price = MoneyMaskedTextController(
      leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');

  @observable
  DateTime date = DateTime.now();

  @observable
  bool loading = false;

  @action
  setPageAndIndex(int index) {
    selectedIndex = index;

    page_controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @action
  setIndex(int index) {
    selectedIndex = index;
  }

  @action
  set_category(Category e) {
    category = e;
  }

  @action
  set_paid(bool? e) {
    is_payed = e;
    print(is_payed);
  }

  @action
  set_dateRange(PickerDateRange dt) async {
    dateRange = dt;
  }

  @action
  get_invoices() async {
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

  @action
  get_categories() async {
    loading = true;
    List<Category> result = await ConnectionManager.get_categories();
    categories = result;
    loading = false;
  }

  @action
  set_date(DateTime dt) {
    date = dt;
  }

  @action
  set_select_invoice(Invoice? I) {
    select_invoice = I;
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

    invoices.forEach((Invoice element) {
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
    });

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

  @action
  logout() async {
    loading = true;

    await StorageLocal.getInstance()
        .then((instance) => instance.remove_credentials());

    loading = false;

    Modular.to.navigate('/login/');
  }

  switch_theme(bool isDarkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isDarkTheme) {
      prefs.setBool('is_dark_theme', true);
    } else {
      prefs.setBool('is_dark_theme', false);
    }
  }
}
