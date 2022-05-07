import 'package:flutter/material.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


Widget SelectDatePopup({required BuildContext context, required HomeStore controller}) {
    return AlertDialog(
      title: const Text("Selecione o dia"),
      content: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs date) =>
            controller.set_date(date.value),
      ),
      actions: <Widget>[
        // define os botões na base do dialogo
        TextButton(
          child: const Text("Selecionar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
