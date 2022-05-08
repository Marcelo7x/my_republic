// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on HomeStoreBase, Store {
  final _$selectedIndexAtom = Atom(name: 'HomeStoreBase.selectedIndex');

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  final _$page_controllerAtom = Atom(name: 'HomeStoreBase.page_controller');

  @override
  PageController get page_controller {
    _$page_controllerAtom.reportRead();
    return super.page_controller;
  }

  @override
  set page_controller(PageController value) {
    _$page_controllerAtom.reportWrite(value, super.page_controller, () {
      super.page_controller = value;
    });
  }

  final _$idAtom = Atom(name: 'HomeStoreBase.id');

  @override
  int? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(int? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$invoicesAtom = Atom(name: 'HomeStoreBase.invoices');

  @override
  List<dynamic>? get invoices {
    _$invoicesAtom.reportRead();
    return super.invoices;
  }

  @override
  set invoices(List<dynamic>? value) {
    _$invoicesAtom.reportWrite(value, super.invoices, () {
      super.invoices = value;
    });
  }

  final _$categoriesAtom = Atom(name: 'HomeStoreBase.categories');

  @override
  List<dynamic> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(List<dynamic> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  final _$invoice_idAtom = Atom(name: 'HomeStoreBase.invoice_id');

  @override
  int? get invoice_id {
    _$invoice_idAtom.reportRead();
    return super.invoice_id;
  }

  @override
  set invoice_id(int? value) {
    _$invoice_idAtom.reportWrite(value, super.invoice_id, () {
      super.invoice_id = value;
    });
  }

  final _$select_invoiceAtom = Atom(name: 'HomeStoreBase.select_invoice');

  @override
  Map<dynamic, dynamic> get select_invoice {
    _$select_invoiceAtom.reportRead();
    return super.select_invoice;
  }

  @override
  set select_invoice(Map<dynamic, dynamic> value) {
    _$select_invoiceAtom.reportWrite(value, super.select_invoice, () {
      super.select_invoice = value;
    });
  }

  final _$is_modifyAtom = Atom(name: 'HomeStoreBase.is_modify');

  @override
  bool get is_modify {
    _$is_modifyAtom.reportRead();
    return super.is_modify;
  }

  @override
  set is_modify(bool value) {
    _$is_modifyAtom.reportWrite(value, super.is_modify, () {
      super.is_modify = value;
    });
  }

  final _$usersAtom = Atom(name: 'HomeStoreBase.users');

  @override
  List<Map<dynamic, dynamic>> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<Map<dynamic, dynamic>> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$total_invoiceAtom = Atom(name: 'HomeStoreBase.total_invoice');

  @override
  int get total_invoice {
    _$total_invoiceAtom.reportRead();
    return super.total_invoice;
  }

  @override
  set total_invoice(int value) {
    _$total_invoiceAtom.reportWrite(value, super.total_invoice, () {
      super.total_invoice = value;
    });
  }

  final _$total_invoice_personAtom =
      Atom(name: 'HomeStoreBase.total_invoice_person');

  @override
  int get total_invoice_person {
    _$total_invoice_personAtom.reportRead();
    return super.total_invoice_person;
  }

  @override
  set total_invoice_person(int value) {
    _$total_invoice_personAtom.reportWrite(value, super.total_invoice_person,
        () {
      super.total_invoice_person = value;
    });
  }

  final _$dateRangeAtom = Atom(name: 'HomeStoreBase.dateRange');

  @override
  PickerDateRange get dateRange {
    _$dateRangeAtom.reportRead();
    return super.dateRange;
  }

  @override
  set dateRange(PickerDateRange value) {
    _$dateRangeAtom.reportWrite(value, super.dateRange, () {
      super.dateRange = value;
    });
  }

  final _$categoryAtom = Atom(name: 'HomeStoreBase.category');

  @override
  Map<String, dynamic> get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(Map<String, dynamic> value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$descriptionAtom = Atom(name: 'HomeStoreBase.description');

  @override
  TextEditingController get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(TextEditingController value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$priceAtom = Atom(name: 'HomeStoreBase.price');

  @override
  MoneyMaskedTextController? get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(MoneyMaskedTextController? value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  final _$dateAtom = Atom(name: 'HomeStoreBase.date');

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  final _$loadingAtom = Atom(name: 'HomeStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$set_dateRangeAsyncAction = AsyncAction('HomeStoreBase.set_dateRange');

  @override
  Future set_dateRange(PickerDateRange dt) {
    return _$set_dateRangeAsyncAction.run(() => super.set_dateRange(dt));
  }

  final _$get_invoicesAsyncAction = AsyncAction('HomeStoreBase.get_invoices');

  @override
  Future get_invoices() {
    return _$get_invoicesAsyncAction.run(() => super.get_invoices());
  }

  final _$get_categoriesAsyncAction =
      AsyncAction('HomeStoreBase.get_categories');

  @override
  Future get_categories() {
    return _$get_categoriesAsyncAction.run(() => super.get_categories());
  }

  final _$add_invoiceAsyncAction = AsyncAction('HomeStoreBase.add_invoice');

  @override
  Future add_invoice() {
    return _$add_invoiceAsyncAction.run(() => super.add_invoice());
  }

  final _$modify_invoiceAsyncAction =
      AsyncAction('HomeStoreBase.modify_invoice');

  @override
  Future modify_invoice() {
    return _$modify_invoiceAsyncAction.run(() => super.modify_invoice());
  }

  final _$remove_invoiceAsyncAction =
      AsyncAction('HomeStoreBase.remove_invoice');

  @override
  Future remove_invoice(
      {required dynamic user_id, required dynamic invoice_id}) {
    return _$remove_invoiceAsyncAction.run(
        () => super.remove_invoice(user_id: user_id, invoice_id: invoice_id));
  }

  final _$calc_totalAsyncAction = AsyncAction('HomeStoreBase.calc_total');

  @override
  Future calc_total() {
    return _$calc_totalAsyncAction.run(() => super.calc_total());
  }

  final _$logoutAsyncAction = AsyncAction('HomeStoreBase.logout');

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase');

  @override
  dynamic setPageAndIndex(int index) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setPageAndIndex');
    try {
      return super.setPageAndIndex(index);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIndex(int index) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setIndex');
    try {
      return super.setIndex(index);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic set_category(Map<String, dynamic> e) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_category');
    try {
      return super.set_category(e);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic set_date(DateTime dt) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_date');
    try {
      return super.set_date(dt);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic set_select_invoice(dynamic I) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_select_invoice');
    try {
      return super.set_select_invoice(I);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clear_input() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.clear_input');
    try {
      return super.clear_input();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedIndex: ${selectedIndex},
page_controller: ${page_controller},
id: ${id},
invoices: ${invoices},
categories: ${categories},
invoice_id: ${invoice_id},
select_invoice: ${select_invoice},
is_modify: ${is_modify},
users: ${users},
total_invoice: ${total_invoice},
total_invoice_person: ${total_invoice_person},
dateRange: ${dateRange},
category: ${category},
description: ${description},
price: ${price},
date: ${date},
loading: ${loading}
    ''';
  }
}
