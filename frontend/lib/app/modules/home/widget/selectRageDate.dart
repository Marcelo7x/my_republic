import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectRageData extends StatefulWidget {
  const SelectRageData({Key? key}) : super(key: key);

  @override
  State<SelectRageData> createState() => _SelectRageDataState();
}

class _SelectRageDataState extends ModularState<SelectRageData, HomeStore> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            title: const Text("Selecione o intevalo"),
            content: SfDateRangePicker(
              view: DateRangePickerView.year,
              initialSelectedRange: controller.dateRange,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs date) =>
                  controller.set_dateRange(date.value),
            ),
            actions: <Widget>[
              // define os botões na base do dialogo
              ElevatedButton(
                child: Text("Confirmar"),
                onPressed: () {
                  controller.get_invoices();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }
}
