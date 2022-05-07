import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  int selectedIndex = 0;

  @observable
  var page_controller = PageController();

  @observable
  bool is_modify = false;

  @action
  setPageAndIndex(int index) {
    selectedIndex = index;
    print(index);
    page_controller.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @action
  setIndex(int index) {
    selectedIndex = index;
  }

  @observable
  PickerDateRange dateRange = PickerDateRange(
      DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 20),
      DateTime.utc(DateTime.now().year, DateTime.now().month, 20));

  @action
  set_dateRange(PickerDateRange dt) async {
    dateRange = dt;

    // if (dt.startDate != null && dt.endDate != null) {
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setStringList('dateRange',
    //       [dt.startDate!.toIso8601String(), dt.endDate!.toIso8601String()]);
    // }
  }

  @observable
  List<dynamic>? invoices;

  @observable
  int? id = Modular.args.data;

  @action
  get_invoices() async {
    if (dateRange.startDate == null || dateRange.endDate == null) {
      return;
    }

    loading = true;

    final prefs = await SharedPreferences.getInstance();
    int? home_id = prefs.getInt('home_id');

    var result = await Dio().post(
      'http://192.168.1.9:8080/list-invoices-date-interval',
      data: jsonEncode([
        {
          'first_date': dateRange.startDate!.toIso8601String().toString(),
          'last_date': dateRange.endDate!.toIso8601String().toString(),
          'homeid': home_id,
        }
      ]),
    );

    invoices = jsonDecode(result.data);

    for (var e in invoices!) {
      e['invoice']['date'] = DateTime.parse(e['invoice']['date']);
    }

    calc_total();

    print(invoices);

    loading = false;
  }

  @observable
  TextEditingController category = TextEditingController();

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

  @observable
  bool loading = false;

  @observable
  int? invoice_id;

  @observable
  Map select_invoice = {};

  @action
  set_select_invoice(I) {
    select_invoice = I;
  }

  modify(e) {
    is_modify = true;
    category.text = e['invoice']['category'];
    description.text = e['invoice']['description'];
    price!.updateValue(int.parse(e['invoice']['price']) / 100);
    date = e['invoice']['date'];
    invoice_id = e['invoice']['invoiceid'];
  }

  @action
  add_invoice() async {
    loading = true;

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');

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
        'http://192.168.1.9:8080/add-invoice',
        data: jsonEncode([
          {
            "description": description.text,
            "category": category.text,
            "price": (price!.numberValue * 100).toInt().toString(),
            "date": date.toIso8601String().toString(),
            "userId": id.toString(),
            "homeId": home_id.toString(),
          }
        ]),
      )
          .then((value) {
        description.text = "";
        category.text = "";
        price!.updateValue(0.00);
        date = DateTime.now();
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

    int? id;
    int? home_id;
    if (logged != null && logged) {
      id = prefs.getInt('id');
    }

    try {
      var result = await Dio()
          .post(
        'http://192.168.1.9:8080/modify-invoice',
        data: jsonEncode([
          {
            "description": description.text,
            "category": category.text,
            "price": (price!.numberValue * 100).toInt().toString(),
            "date": date.toIso8601String().toString(),
            "userId": id.toString(),
            "invoiceId": invoice_id.toString(),
          }
        ]),
      )
          .then((value) {
        description.text = "";
        category.text = "";
        price!.updateValue(0.00);
        date = DateTime.now();
      });
    } on Exception catch (e) {
      print('modify_invoice:  nao conseguiu modificar invoice');
      print(e);
    }

    loading = false;
  }

  @action
  remove_invoice({required user_id, required invoice_id}) async {
    loading = true;

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');

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
        'http://192.168.1.9:8080/remove-invoice',
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

  @observable
  int total_invoice = 0;
  int total_invoice_person = 0;

  @observable
  List<Map<dynamic, dynamic>> users = [{}];

  @action
  calc_total() async {
    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');

    int? home_id;
    if (logged != null && logged) {
      home_id = prefs.getInt('home_id');
    }

    int? num_users;
    try {
      var result = await Dio().post(
        'http://192.168.1.9:8080/number-users',
        data: jsonEncode([
          {
            "homeId": home_id.toString(),
          }
        ]),
      );

      List<dynamic> data = jsonDecode(result.data);

      num_users = data[0][""]?["count"];
    } on Exception catch (e) {
      print('calc_total:  nao conseguiu obter o numero de users');
      print(e);
    }

    total_invoice = 0;
    users = [{}];
    var aux = [{}];

    invoices?.forEach((element) {
      total_invoice += int.parse(element['invoice']['price']);
      aux[0][element['invoice']['userid']] =
          aux[0][element['invoice']['userid']] == null
              ? {
                  'value': int.parse(element['invoice']['price']),
                  'name': element['users']['name']
                }
              : {
                  'value': aux[0][element['invoice']['userid']]['value']! +
                      int.parse(element['invoice']['price']),
                  'name': element['users']['name']
                };
    });

    if (total_invoice % num_users! == 0) {
      total_invoice_person = total_invoice ~/ num_users;
    } else {
      total_invoice_person = (total_invoice / num_users + 1).toInt();
    }

    aux[0].forEach((id, value) {
      users.add({
        id: ((((value['value'] * 100) / total_invoice)) / 100),
        'r': Random().nextInt(255),
        'g': Random().nextInt(255),
        'b': Random().nextInt(255),
        'name': value['name']
      });
    });
    users.removeAt(0);

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
}
