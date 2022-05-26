import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
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
  List<dynamic>? invoices;

  @observable
  List<Category> categories = [];

  @observable
  int? invoice_id;

  @observable
  Map select_invoice = {};

  @observable
  bool is_modify = false;

  @observable
  List<Map<dynamic, dynamic>> users = [{}];

  @observable
  List<Map<dynamic, dynamic>> category_percents = [{}];

  @observable
  int total_invoice = 0;

  @observable
  int any_payed = 0;

  @observable
  int total_invoice_person = 0;

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

    invoices = await ConnectionManager.get_invoices(start_date: dateRange.startDate!, end_date: dateRange.endDate!, home_id: home.id);

    for (var e in invoices!) {
      e['invoice']['date'] = DateTime.parse(e['invoice']['date']);
    }

    loading = false;
  }

  @action
  get_categories() async {
    loading = true;

    List<Category> result = await ConnectionManager.get_categories();

    categories = result;

    print(result);

    loading = false;
  }

  @action
  set_date(DateTime dt) {
    date = dt;
  }

  @action
  set_select_invoice(I) {
    select_invoice = I;
  }

  modify(e) {
    is_modify = true;
    description.text = e['invoice']['description'];
    price!.updateValue(int.parse(e['invoice']['price']) / 100);
    date = e['invoice']['date'];
    invoice_id = e['invoice']['invoiceid'];
    is_payed = e['invoice']['paid'];
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
    loading = true;

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');
    String url = await SharedPreferences.getInstance()
        .then((value) => value.getString('url')!);

    int? id;
    int? home_id;
    if (logged != null && logged) {
      id = prefs.getInt('id');
      home_id = prefs.getInt('home_id');
      print(home_id);
    }

    try {
      var result = await Dio()
          .post(
        url + 'add-invoice',
        data: jsonEncode([
          {
            "description": description.text,
            "categoryId": category!.id,
            "price": (price!.numberValue * 100).toInt().toString(),
            "date": date.toIso8601String().toString(),
            "userId": id.toString(),
            "homeId": home_id.toString(),
            "paid": is_payed
          }
        ]),
      )
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

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');
    String url = await SharedPreferences.getInstance()
        .then((value) => value.getString('url')!);

    int? id;
    int? home_id;
    if (logged != null && logged) {
      id = prefs.getInt('id');
    }

    try {
      var result = await Dio()
          .post(
        url + 'modify-invoice',
        data: jsonEncode([
          {
            "description": description.text,
            "categoryId": category!.id,
            "price": (price!.numberValue * 100).toInt().toString(),
            "date": date.toIso8601String().toString(),
            "userId": id.toString(),
            "invoiceId": invoice_id.toString(),
            "paid": is_payed
          }
        ]),
      )
          .then((value) {
        description.text = "";
        category = null;
        price!.updateValue(0.00);
        date = DateTime.now();
        is_payed = null;
      });
    } on Exception catch (e) {
      print('modify_invoice:  nao conseguiu modificar invoice');
      print(e);
    }

    is_modify = false;
    loading = false;
  }

  @action
  remove_invoice({required user_id, required invoice_id}) async {
    loading = true;

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');
    String url = await SharedPreferences.getInstance()
        .then((value) => value.getString('url')!);

    int? id;
    int? home_id;
    if (logged != null && logged) {
      id = prefs.getInt('id');
      if (id != user_id) {
        loading = false;
        return;
      }
    }
    print("$id $invoice_id");

    try {
      var result = await Dio().post(
        url + 'remove-invoice',
        data: jsonEncode([
          {
            "userId": id.toString(),
            "invoiceId": invoice_id.toString(),
          }
        ]),
      );
    } on Exception catch (e) {
      print('remove_invoice:  nao conseguiu remover invoice');
      print(e);
    }

    loading = false;
  }

  @action
  calc_total() async {
    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');
    String url = await SharedPreferences.getInstance()
        .then((value) => value.getString('url')!);

    int? home_id;
    if (logged != null && logged) {
      home_id = prefs.getInt('home_id');
    }

    total_invoice = 0;
    total_invoice_person = 0;
    any_payed = 0;
    users.clear();
    category_percents = [{}];
    var aux = [{}];
    var aux_category = [{}];

    int? num_users;
    try {
      var result = await Dio().post(
        url + 'number-users',
        data: jsonEncode([
          {
            "homeId": home_id.toString(),
          }
        ]),
      );

      List<dynamic>? data = jsonDecode(result.data);

      num_users = data!.length;

      //print("data: $data");

      data.forEach((e) {
        aux[0][e['users']['userid']] = {
          'value': 0,
          'name': e['users']['name'],
          'paid': 0,
        };
      });
      //print(aux);
    } on Exception catch (e) {
      print('calc_total:  nao conseguiu obter o numero de users');
      print(e);
    }

    invoices?.forEach((element) {
      total_invoice += int.parse(element['invoice']['price']);
      any_payed += element['invoice']['paid'] == false
          ? int.parse(element['invoice']['price'])
          : 0;
      aux[0][element['invoice']['userid']] = {
        'value': aux[0][element['invoice']['userid']]['value']! +
            int.parse(element['invoice']['price']),
        'name': element['users']['name'],
        'paid': element['invoice']['paid'] == true
            ? aux[0][element['invoice']['userid']]['paid']! +
                int.parse(element['invoice']['price'])
            : aux[0][element['invoice']['userid']]['paid']!,
      };

      aux_category[0][element['category']['name']] =
          aux_category[0][element['category']['name']] == null
              ? {
                  'value': int.parse(element['invoice']['price']),
                  'name': element['category']['name']
                }
              : {
                  'value': aux_category[0][element['category']['name']]
                          ['value']! +
                      int.parse(element['invoice']['price']),
                  'name': element['category']['name']
                };
    });

    if (((total_invoice / num_users!) - (any_payed / num_users)) % num_users ==
        0) {
      total_invoice_person =
          ((total_invoice / num_users) - (any_payed / num_users)).toInt();
    } else {
      total_invoice_person =
          ((total_invoice / num_users) - (any_payed / num_users) + 1).toInt();
    }

    aux[0].forEach((id, value) {
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

    aux_category[0].forEach((id, value) {
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', -1);
    await prefs.setBool('is_logged', false);

    loading = false;

    Modular.to.navigate('/login/');
  }

  switch_theme(bool is_dark_theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (is_dark_theme) {
      prefs.setBool('is_dark_theme', true);
    } else {
      prefs.setBool('is_dark_theme', false);
    }
  }
}
