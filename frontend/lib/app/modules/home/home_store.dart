import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/balance/balance_store.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:frontend/app/modules/home/notifications/notifications_models.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  User user = User.fromMap(
      Modular.get<JwtDecodeServiceImpl>().getPayload(Modular.args.data));
  Home home = Home(Modular.get<JwtDecodeServiceImpl>()
          .getPayload(Modular.args.data)['homeid'] ??
      -1);

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
  load(bool value) {
    loading = value;
  }

  @observable
  int useridSelected = -1;

  @action
  setUseridSelected(userid) {
    useridSelected = userid;
  }

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

  @observable
  List<NotificationItem> notifications = [];

  @action
  logout() async {
    loading = true;

    await StorageLocal.getInstance()
        .then((instance) => instance.removeCredentials());

    loading = false;

    // ConnectionManager.removeInterceptors();
    Modular.to.navigate('/login/');
  }

  @observable
  bool isLiveInHome = false;

  @action
  verifyIfIsLiveInHome() async {
    final cm = Modular.get<ConnectionManager>();

    try {
      isLiveInHome = await cm.getEntryRequest();
    } on ConnectionManagerError catch (e) {}
  }

  @observable
  List<Map<String, dynamic>> usersEntryRequest = [];

  @action
  getEntryRequest() async {
    final cm = Modular.get<ConnectionManager>();

    try {
      final result = await cm.verifyEntryRequest();

      usersEntryRequest = [];
      notifications = [];
      for (var el in result) {
        usersEntryRequest.add(el);
      }

      for (var el in usersEntryRequest) {
        notifications.add(EntryRequest(
            userid: el['userid'],
            title: '${el['firstname']} ${el['lastname']}',
            message: 'Enviou um pedido para entrar para a sua república'));
      }
    } on ConnectionManagerError catch (e) {}
  }

  @action
  reload() async {
    await verifyIfIsLiveInHome();

    if (home != null && home.id != -1) getEntryRequest();

    if (!isLiveInHome) {
      await Modular.get<InvoiceStore>().getInvoices();
      await Modular.get<InvoiceStore>().getCategories();
      await Modular.get<BalanceStore>().calcTotal();
    }
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
