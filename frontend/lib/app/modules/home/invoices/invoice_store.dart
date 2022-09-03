import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/invoice.dart';
import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';

part 'invoice_store.g.dart';

class InvoiceStore = InvoiceStoreBase with _$InvoiceStore;

abstract class InvoiceStoreBase with Store {
  InvoiceStoreBase() {
    final token = Modular.args.data;
    JwtDecodeService jwt = Modular.get<JwtDecodeServiceImpl>();
    Map<String, dynamic> payload = jwt.getPayload(token);

    this.home = Home(payload['homeid']);
    this.user = User(payload['userid'], home: this.home);
  }

  late User user;
  late Home home;

  @observable
  bool loading = false;

  @observable
  List<Invoice> invoices = [];

  @action
  getInvoices() async {
    final dateRange = Modular.get<HomeStore>().dateRange;
    if (dateRange.startDate == null || dateRange.endDate == null) {
      return;
    }

    loading = true;

    await ConnectionManager.initApiClient();

    var result = await ConnectionManager.get_invoices(
        start_date: dateRange.startDate!,
        end_date: dateRange.endDate!,
        home_id: home.id);

    invoices.clear();

    for (var e in result) {
      User u = User(e['userid'], name: e['firstname']);
      invoices.add(Invoice(
          id: e['invoiceid'],
          user: u,
          home: home,
          category: Category(
              id: e['categoryid'], name: e['name']),
          price: e['price'],
          description: e['description'],
          date: DateTime.parse(e['date']),
          paid: e['paid'] == 'unpaid'
              ? null
              : e['paid'] == 'payed'
                  ? false
                  : true)); //! to Enum
    }

    loading = false;
  }

  @observable
  Invoice? selectedInvoice;

  @action
  selectInvoice(Invoice? I) {
    selectedInvoice = I;
  }

  @observable
  int? invoiceId;

  @observable
  bool isModify = false;

  @observable
  bool? isPayed;

  @action
  setPaid(bool? e) {
    isPayed = e;
    print(isPayed);
  }

  @observable
  Category? category;

  @action
  setCategory(Category e) {
    category = e;
  }

  @observable
  TextEditingController description = TextEditingController();

  @observable
  MoneyMaskedTextController? price = MoneyMaskedTextController(
      leftSymbol: "R\$ ", decimalSeparator: ',', thousandSeparator: '.');

  @observable
  DateTime date = DateTime.now();

  @action
  setDate(DateTime dt) {
    date = dt;
  }

  modify() {
    isModify = true;
    description.text = selectedInvoice!.description;
    price!.updateValue(selectedInvoice!.price / 100);
    date = selectedInvoice!.date;
    invoiceId = selectedInvoice!.id;
    isPayed = selectedInvoice!.paid;
  }

  @action
  clearInput() {
    description.text = "";
    category = null;
    price!.updateValue(0.00);
    date = DateTime.now();
    isModify = false;
    isPayed = null;
  }

  @action
  addInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.add_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              homeId: home.id,
              isPayed: isPayed == null
                  ? "unpaid"
                  : isPayed == false
                      ? "payed"
                      : "anypayed")
          .then((value) {
        clearInput();
      });
    } on Exception catch (e) {
      print('add_invoice:  nao conseguiu adicionar invoice');
      print(e);
    }

    loading = false;
  }

  @action
  modifyInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.modify_invoice(
              description: description.text,
              categoryId: category!.id,
              price: (price!.numberValue * 100).toInt(),
              date: date,
              userId: user.id,
              invoiceId: invoiceId!,
              isPayed: isPayed)
          .then((value) {
        clearInput();
      });
    } on Exception catch (e) {
      print('modify_invoice:  nao conseguiu modificar invoice');
      print(e);
    }

    isModify = false;
    loading = false;
  }

  @action
  removeInvoice() async {
    loading = true;
    try {
      var result = await ConnectionManager.remove_invoice(
        invoiceid: selectedInvoice!.id,
      );
    } on Exception catch (e) {
      print('remove_invoice:  nao conseguiu remover invoice');
      print(e);
    }

    loading = false;
  }

  @observable
  List<Category> categories = [];

  @action
  getCategories() async {
    loading = true;
    List<Category> result = await ConnectionManager.get_categories();
    categories = result;
    loading = false;
  }
}
