// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BalanceStore on BalanceStoreBase, Store {
  late final _$totalInvoiceAtom =
      Atom(name: 'BalanceStoreBase.totalInvoice', context: context);

  @override
  num get totalInvoice {
    _$totalInvoiceAtom.reportRead();
    return super.totalInvoice;
  }

  @override
  set totalInvoice(num value) {
    _$totalInvoiceAtom.reportWrite(value, super.totalInvoice, () {
      super.totalInvoice = value;
    });
  }

  late final _$anyPayedAtom =
      Atom(name: 'BalanceStoreBase.anyPayed', context: context);

  @override
  num get anyPayed {
    _$anyPayedAtom.reportRead();
    return super.anyPayed;
  }

  @override
  set anyPayed(num value) {
    _$anyPayedAtom.reportWrite(value, super.anyPayed, () {
      super.anyPayed = value;
    });
  }

  late final _$totalInvoicePersonAtom =
      Atom(name: 'BalanceStoreBase.totalInvoicePerson', context: context);

  @override
  num get totalInvoicePerson {
    _$totalInvoicePersonAtom.reportRead();
    return super.totalInvoicePerson;
  }

  @override
  set totalInvoicePerson(num value) {
    _$totalInvoicePersonAtom.reportWrite(value, super.totalInvoicePerson, () {
      super.totalInvoicePerson = value;
    });
  }

  late final _$categoryPercentsAtom =
      Atom(name: 'BalanceStoreBase.categoryPercents', context: context);

  @override
  Map<String, dynamic> get categoryPercents {
    _$categoryPercentsAtom.reportRead();
    return super.categoryPercents;
  }

  @override
  set categoryPercents(Map<String, dynamic> value) {
    _$categoryPercentsAtom.reportWrite(value, super.categoryPercents, () {
      super.categoryPercents = value;
    });
  }

  late final _$residentsAtom =
      Atom(name: 'BalanceStoreBase.residents', context: context);

  @override
  Map<int, dynamic> get residents {
    _$residentsAtom.reportRead();
    return super.residents;
  }

  @override
  set residents(Map<int, dynamic> value) {
    _$residentsAtom.reportWrite(value, super.residents, () {
      super.residents = value;
    });
  }

  late final _$getResidentsAsyncAction =
      AsyncAction('BalanceStoreBase.getResidents', context: context);

  @override
  Future getResidents() {
    return _$getResidentsAsyncAction.run(() => super.getResidents());
  }

  late final _$calcTotalAsyncAction =
      AsyncAction('BalanceStoreBase.calcTotal', context: context);

  @override
  Future calcTotal() {
    return _$calcTotalAsyncAction.run(() => super.calcTotal());
  }

  @override
  String toString() {
    return '''
totalInvoice: ${totalInvoice},
anyPayed: ${anyPayed},
totalInvoicePerson: ${totalInvoicePerson},
categoryPercents: ${categoryPercents},
residents: ${residents}
    ''';
  }
}
