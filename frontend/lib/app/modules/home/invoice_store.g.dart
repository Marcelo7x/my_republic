// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InvoiceStore on InvoiceStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: 'InvoiceStoreBase.loading', context: context);

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

  late final _$invoicesAtom =
      Atom(name: 'InvoiceStoreBase.invoices', context: context);

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

  late final _$selectedInvoiceAtom =
      Atom(name: 'InvoiceStoreBase.selectedInvoice', context: context);

  @override
  Invoice? get selectedInvoice {
    _$selectedInvoiceAtom.reportRead();
    return super.selectedInvoice;
  }

  @override
  set selectedInvoice(Invoice? value) {
    _$selectedInvoiceAtom.reportWrite(value, super.selectedInvoice, () {
      super.selectedInvoice = value;
    });
  }

  late final _$invoiceIdAtom =
      Atom(name: 'InvoiceStoreBase.invoiceId', context: context);

  @override
  int? get invoiceId {
    _$invoiceIdAtom.reportRead();
    return super.invoiceId;
  }

  @override
  set invoiceId(int? value) {
    _$invoiceIdAtom.reportWrite(value, super.invoiceId, () {
      super.invoiceId = value;
    });
  }

  late final _$isModifyAtom =
      Atom(name: 'InvoiceStoreBase.isModify', context: context);

  @override
  bool get isModify {
    _$isModifyAtom.reportRead();
    return super.isModify;
  }

  @override
  set isModify(bool value) {
    _$isModifyAtom.reportWrite(value, super.isModify, () {
      super.isModify = value;
    });
  }

  late final _$isPayedAtom =
      Atom(name: 'InvoiceStoreBase.isPayed', context: context);

  @override
  bool? get isPayed {
    _$isPayedAtom.reportRead();
    return super.isPayed;
  }

  @override
  set isPayed(bool? value) {
    _$isPayedAtom.reportWrite(value, super.isPayed, () {
      super.isPayed = value;
    });
  }

  late final _$categoryAtom =
      Atom(name: 'InvoiceStoreBase.category', context: context);

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

  late final _$descriptionAtom =
      Atom(name: 'InvoiceStoreBase.description', context: context);

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

  late final _$priceAtom =
      Atom(name: 'InvoiceStoreBase.price', context: context);

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

  late final _$dateAtom = Atom(name: 'InvoiceStoreBase.date', context: context);

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

  late final _$categoriesAtom =
      Atom(name: 'InvoiceStoreBase.categories', context: context);

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

  late final _$getInvoicesAsyncAction =
      AsyncAction('InvoiceStoreBase.getInvoices', context: context);

  @override
  Future getInvoices() {
    return _$getInvoicesAsyncAction.run(() => super.getInvoices());
  }

  late final _$addInvoiceAsyncAction =
      AsyncAction('InvoiceStoreBase.addInvoice', context: context);

  @override
  Future addInvoice() {
    return _$addInvoiceAsyncAction.run(() => super.addInvoice());
  }

  late final _$modifyInvoiceAsyncAction =
      AsyncAction('InvoiceStoreBase.modifyInvoice', context: context);

  @override
  Future modifyInvoice() {
    return _$modifyInvoiceAsyncAction.run(() => super.modifyInvoice());
  }

  late final _$removeInvoiceAsyncAction =
      AsyncAction('InvoiceStoreBase.removeInvoice', context: context);

  @override
  Future removeInvoice() {
    return _$removeInvoiceAsyncAction.run(() => super.removeInvoice());
  }

  late final _$getCategoriesAsyncAction =
      AsyncAction('InvoiceStoreBase.getCategories', context: context);

  @override
  Future getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  late final _$InvoiceStoreBaseActionController =
      ActionController(name: 'InvoiceStoreBase', context: context);

  @override
  dynamic selectInvoice(Invoice? I) {
    final _$actionInfo = _$InvoiceStoreBaseActionController.startAction(
        name: 'InvoiceStoreBase.selectInvoice');
    try {
      return super.selectInvoice(I);
    } finally {
      _$InvoiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPaid(bool? e) {
    final _$actionInfo = _$InvoiceStoreBaseActionController.startAction(
        name: 'InvoiceStoreBase.setPaid');
    try {
      return super.setPaid(e);
    } finally {
      _$InvoiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCategory(Category e) {
    final _$actionInfo = _$InvoiceStoreBaseActionController.startAction(
        name: 'InvoiceStoreBase.setCategory');
    try {
      return super.setCategory(e);
    } finally {
      _$InvoiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDate(DateTime dt) {
    final _$actionInfo = _$InvoiceStoreBaseActionController.startAction(
        name: 'InvoiceStoreBase.setDate');
    try {
      return super.setDate(dt);
    } finally {
      _$InvoiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearInput() {
    final _$actionInfo = _$InvoiceStoreBaseActionController.startAction(
        name: 'InvoiceStoreBase.clearInput');
    try {
      return super.clearInput();
    } finally {
      _$InvoiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
invoices: ${invoices},
selectedInvoice: ${selectedInvoice},
invoiceId: ${invoiceId},
isModify: ${isModify},
isPayed: ${isPayed},
category: ${category},
description: ${description},
price: ${price},
date: ${date},
categories: ${categories}
    ''';
  }
}
