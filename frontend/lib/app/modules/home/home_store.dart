import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/invoice_store.dart';
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

  PageController page_controller = PageController();

  @observable
  PickerDateRange dateRange = PickerDateRange(
      DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 20),
      DateTime.utc(DateTime.now().year, DateTime.now().month, 20));

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
  set_dateRange(PickerDateRange dt) async {
    dateRange = dt;
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
