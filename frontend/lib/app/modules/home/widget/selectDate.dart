import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectData extends StatefulWidget {
  const SelectData({Key? key}) : super(key: key);

  @override
  State<SelectData> createState() => _SelectDataState();
}

class _SelectDataState extends ModularState<SelectData, HomeStore> {
  @override
  Widget build(BuildContext context) {
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
          child: Text("Fechar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
