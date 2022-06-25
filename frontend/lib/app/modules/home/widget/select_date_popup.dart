import 'package:flutter/material.dart';
import 'package:frontend/app/modules/home/invoices/invoice_store.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget SelectDatePopup(
    {required BuildContext context, required InvoiceStore invoicesController}) {
  return AlertDialog(
    title: const Text("Selecione o dia"),
    content: SizedBox(
      height: MediaQuery.of(context).size.height * .4,
      width: MediaQuery.of(context).size.width * .6,
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs date) =>
            invoicesController.setDate(date.value),
      ),
    ),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: <Widget>[
      // define os botões na base do dialogo
      ElevatedButton(
        child: const Text("Selecionar"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text(
          "Cancelar",
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
