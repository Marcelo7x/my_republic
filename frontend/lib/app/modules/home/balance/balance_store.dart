import 'dart:math';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';

part 'balance_store.g.dart';

class BalanceStore = BalanceStoreBase with _$BalanceStore;

abstract class BalanceStoreBase with Store {
  User user = User.fromMap(
      Modular.get<JwtDecodeServiceImpl>().getPayload(Modular.args.data));
  Home home = Home(Modular.get<JwtDecodeServiceImpl>()
      .getPayload(Modular.args.data)['homeid'] ?? -1);

  InvoiceStore invoicesController = Modular.get<InvoiceStore>();

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
    final cm = Modular.get<ConnectionManager>();

    try {
      var data = await cm.number_users(homeId: home.id);

      data.forEach((e) {
        residents[e['userid']] = {
          'value': 0,
          'name': e['firstname'],
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

    await getResidents();

    for (var element in invoicesController.invoices) {
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
