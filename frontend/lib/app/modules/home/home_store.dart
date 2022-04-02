import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  int selectedIndex = 0;

  @action
  setIndex(int index) {
    selectedIndex = index;
  }

  @observable
  PickerDateRange dateRange = PickerDateRange(
      DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 20),
      DateTime.utc(DateTime.now().year, DateTime.now().month, 20));

  @action
  set_dateRange(PickerDateRange dt) {
    dateRange = dt;
  }

  @observable
  List<dynamic>? invoices;

  @action
  get_invoices() async {
    var result = await Dio().post(
      'http://192.168.1.9:8080/list-invoices-date-interval',
      data: jsonEncode([
        {
          'first_date': dateRange.startDate!.toIso8601String().toString(),
          'last_date': dateRange.endDate!.toIso8601String().toString(),
        }
      ]),
    );

    invoices = jsonDecode(result.data);

    for (var e in invoices!) {
      e['invoice']['date'] = DateTime.parse(e['invoice']['date']);
    }

    print(invoices);
  }
}
