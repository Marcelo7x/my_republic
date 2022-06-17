// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$selectedIndexAtom =
      Atom(name: 'HomeStoreBase.selectedIndex', context: context);

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

  late final _$invoicesAtom =
      Atom(name: 'HomeStoreBase.invoices', context: context);

  @override
  List<Invoice> get invoices {
    _$invoicesAtom.reportRead();
    return super.invoices;
  }

  @override
  set invoices(List<Invoice> value) {
    _$invoicesAtom.reportWrite(value, super.invoices, () {
      super.invoices = value;
    });
  }

  late final _$select_invoiceAtom =
      Atom(name: 'HomeStoreBase.select_invoice', context: context);

  @override
  Invoice? get select_invoice {
    _$select_invoiceAtom.reportRead();
    return super.select_invoice;
  }

  @override
  set select_invoice(Invoice? value) {
    _$select_invoiceAtom.reportWrite(value, super.select_invoice, () {
      super.select_invoice = value;
    });
  }

  late final _$categoriesAtom =
      Atom(name: 'HomeStoreBase.categories', context: context);

  @override
  List<Category> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(List<Category> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$invoice_idAtom =
      Atom(name: 'HomeStoreBase.invoice_id', context: context);

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

  late final _$is_modifyAtom =
      Atom(name: 'HomeStoreBase.is_modify', context: context);

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

  late final _$usersAtom = Atom(name: 'HomeStoreBase.users', context: context);

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

  late final _$category_percentsAtom =
      Atom(name: 'HomeStoreBase.category_percents', context: context);

  @override
  List<Map<dynamic, dynamic>> get category_percents {
    _$category_percentsAtom.reportRead();
    return super.category_percents;
  }

  @override
  set category_percents(List<Map<dynamic, dynamic>> value) {
    _$category_percentsAtom.reportWrite(value, super.category_percents, () {
      super.category_percents = value;
    });
  }

  late final _$total_invoiceAtom =
      Atom(name: 'HomeStoreBase.total_invoice', context: context);

  @override
  num get total_invoice {
    _$total_invoiceAtom.reportRead();
    return super.total_invoice;
  }

  @override
  set total_invoice(num value) {
    _$total_invoiceAtom.reportWrite(value, super.total_invoice, () {
      super.total_invoice = value;
    });
  }

  late final _$any_payedAtom =
      Atom(name: 'HomeStoreBase.any_payed', context: context);

  @override
  num get any_payed {
    _$any_payedAtom.reportRead();
    return super.any_payed;
  }

  @override
  set any_payed(num value) {
    _$any_payedAtom.reportWrite(value, super.any_payed, () {
      super.any_payed = value;
    });
  }

  late final _$total_invoice_personAtom =
      Atom(name: 'HomeStoreBase.total_invoice_person', context: context);

  @override
  num get total_invoice_person {
    _$total_invoice_personAtom.reportRead();
    return super.total_invoice_person;
  }

  @override
  set total_invoice_person(num value) {
    _$total_invoice_personAtom.reportWrite(value, super.total_invoice_person,
        () {
      super.total_invoice_person = value;
    });
  }

  late final _$dateRangeAtom =
      Atom(name: 'HomeStoreBase.dateRange', context: context);

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

  late final _$categoryAtom =
      Atom(name: 'HomeStoreBase.category', context: context);

  @override
  Category? get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(Category? value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  late final _$is_payedAtom =
      Atom(name: 'HomeStoreBase.is_payed', context: context);

  @override
  bool? get is_payed {
    _$is_payedAtom.reportRead();
    return super.is_payed;
  }

  @override
  set is_payed(bool? value) {
    _$is_payedAtom.reportWrite(value, super.is_payed, () {
      super.is_payed = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: 'HomeStoreBase.description', context: context);

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

  late final _$priceAtom = Atom(name: 'HomeStoreBase.price', context: context);

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

  late final _$dateAtom = Atom(name: 'HomeStoreBase.date', context: context);

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

  late final _$loadingAtom =
      Atom(name: 'HomeStoreBase.loading', context: context);

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

  late final _$set_dateRangeAsyncAction =
      AsyncAction('HomeStoreBase.set_dateRange', context: context);

  @override
  Future set_dateRange(PickerDateRange dt) {
    return _$set_dateRangeAsyncAction.run(() => super.set_dateRange(dt));
  }

  late final _$get_invoicesAsyncAction =
      AsyncAction('HomeStoreBase.get_invoices', context: context);

  @override
  Future get_invoices() {
    return _$get_invoicesAsyncAction.run(() => super.get_invoices());
  }

  late final _$get_categoriesAsyncAction =
      AsyncAction('HomeStoreBase.get_categories', context: context);

  @override
  Future get_categories() {
    return _$get_categoriesAsyncAction.run(() => super.get_categories());
  }

  late final _$add_invoiceAsyncAction =
      AsyncAction('HomeStoreBase.add_invoice', context: context);

  @override
  Future add_invoice() {
    return _$add_invoiceAsyncAction.run(() => super.add_invoice());
  }

  late final _$modify_invoiceAsyncAction =
      AsyncAction('HomeStoreBase.modify_invoice', context: context);

  @override
  Future modify_invoice() {
    return _$modify_invoiceAsyncAction.run(() => super.modify_invoice());
  }

  late final _$remove_invoiceAsyncAction =
      AsyncAction('HomeStoreBase.remove_invoice', context: context);

  @override
  Future remove_invoice() {
    return _$remove_invoiceAsyncAction.run(() => super.remove_invoice());
  }

  late final _$calc_totalAsyncAction =
      AsyncAction('HomeStoreBase.calc_total', context: context);

  @override
  Future calc_total() {
    return _$calc_totalAsyncAction.run(() => super.calc_total());
  }

  late final _$logoutAsyncAction =
      AsyncAction('HomeStoreBase.logout', context: context);

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

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
  dynamic set_category(Category e) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_category');
    try {
      return super.set_category(e);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic set_paid(bool? e) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_paid');
    try {
      return super.set_paid(e);
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
  dynamic set_select_invoice(Invoice? I) {
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
invoices: ${invoices},
select_invoice: ${select_invoice},
categories: ${categories},
invoice_id: ${invoice_id},
is_modify: ${is_modify},
users: ${users},
category_percents: ${category_percents},
total_invoice: ${total_invoice},
any_payed: ${any_payed},
total_invoice_person: ${total_invoice_person},
dateRange: ${dateRange},
category: ${category},
is_payed: ${is_payed},
description: ${description},
price: ${price},
date: ${date},
loading: ${loading}
    ''';
  }
}
