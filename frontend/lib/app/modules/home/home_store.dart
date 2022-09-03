import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';

import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  

  User user = User.fromMap(Modular.get<JwtDecodeServiceImpl>().getPayload(Modular.args.data));
  Home home = Home(Modular.get<JwtDecodeServiceImpl>().getPayload(Modular.args.data)['homeid']);

  @observable
  int selectedIndex = 0;

  PageController page_controller = PageController();

  @observable
  PickerDateRange dateRange = DateTime.now().day < 20
      ? PickerDateRange(
          DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 20),
          DateTime.utc(DateTime.now().year, DateTime.now().month, 20))
      : PickerDateRange(
          DateTime.utc(DateTime.now().year, DateTime.now().month, 20),
          DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 20));

  @observable
  bool loading = false;

  @action
  setPageAndIndex(int index) {
    setIndex(index);

    page_controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @action
  setIndex(int index) {
    selectedIndex = index;
  }

  @action
  setDateRange(PickerDateRange dt) async {
    dateRange = dt;
  }

  @action
  logout() async {
    loading = true;

    await StorageLocal.getInstance()
        .then((instance) => instance.removeCredentials());

    loading = false;

    Modular.to.navigate('/login/');
  }

  @action
  reload() async {
    await Modular.get<InvoiceStore>().getInvoices();
    await Modular.get<InvoiceStore>().getCategories();
    await Modular.get<BalanceStore>().calcTotal();
  }

  switchTheme(bool isDarkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isDarkTheme) {
      prefs.setBool('is_dark_theme', true);
    } else {
      prefs.setBool('is_dark_theme', false);
    }
  }
}
