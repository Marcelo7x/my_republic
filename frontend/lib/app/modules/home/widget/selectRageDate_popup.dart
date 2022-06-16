import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget SelectRageDatePopup(BuildContext context, HomeStore controller) {
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
        child: const Text("Confirmar"),
        onPressed: () {
          controller.get_invoices();
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Widget SelectDateInterval(BuildContext context, HomeStore controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Intervalo: "),
      GestureDetector(
        child: Observer(builder: (_) {
          return Text(
              "${controller.dateRange.startDate?.day}/${controller.dateRange.startDate?.month}/${controller.dateRange.startDate?.year} a ${controller.dateRange.endDate?.day}/${controller.dateRange.endDate?.month}/${controller.dateRange.endDate?.year}",
              style: TextStyle(color: Theme.of(context).colorScheme.primary));
        }),
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return SelectRageDatePopup(context, controller);
          },
        ),
      ),
      GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return SelectRageDatePopup(context, controller);
          },
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.calendar_month,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ],
  );
}
