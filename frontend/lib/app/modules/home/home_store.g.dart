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

  final _$categoryAtom = Atom(name: 'HomeStoreBase.category');

  @override
  TextEditingController get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(TextEditingController value) {
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

  final _$get_invoicesAsyncAction = AsyncAction('HomeStoreBase.get_invoices');

  @override
  Future get_invoices() {
    return _$get_invoicesAsyncAction.run(() => super.get_invoices());
  }

  final _$add_invoiceAsyncAction = AsyncAction('HomeStoreBase.add_invoice');

  @override
  Future add_invoice() {
    return _$add_invoiceAsyncAction.run(() => super.add_invoice());
  }

  final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase');

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
  dynamic set_dateRange(PickerDateRange dt) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.set_dateRange');
    try {
      return super.set_dateRange(dt);
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
  String toString() {
    return '''
selectedIndex: ${selectedIndex},
dateRange: ${dateRange},
invoices: ${invoices},
category: ${category},
description: ${description},
price: ${price},
date: ${date},
loading: ${loading}
    ''';
  }
}
