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

  late final _$useridSelectedAtom =
      Atom(name: 'HomeStoreBase.useridSelected', context: context);

  @override
  int get useridSelected {
    _$useridSelectedAtom.reportRead();
    return super.useridSelected;
  }

  @override
  set useridSelected(int value) {
    _$useridSelectedAtom.reportWrite(value, super.useridSelected, () {
      super.useridSelected = value;
    });
  }

  late final _$notificationsAtom =
      Atom(name: 'HomeStoreBase.notifications', context: context);

  @override
  List<NotificationItem> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(List<NotificationItem> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$isLiveInHomeAtom =
      Atom(name: 'HomeStoreBase.isLiveInHome', context: context);

  @override
  bool get isLiveInHome {
    _$isLiveInHomeAtom.reportRead();
    return super.isLiveInHome;
  }

  @override
  set isLiveInHome(bool value) {
    _$isLiveInHomeAtom.reportWrite(value, super.isLiveInHome, () {
      super.isLiveInHome = value;
    });
  }

  late final _$usersEntryRequestAtom =
      Atom(name: 'HomeStoreBase.usersEntryRequest', context: context);

  @override
  List<Map<String, dynamic>> get usersEntryRequest {
    _$usersEntryRequestAtom.reportRead();
    return super.usersEntryRequest;
  }

  @override
  set usersEntryRequest(List<Map<String, dynamic>> value) {
    _$usersEntryRequestAtom.reportWrite(value, super.usersEntryRequest, () {
      super.usersEntryRequest = value;
    });
  }

  late final _$setDateRangeAsyncAction =
      AsyncAction('HomeStoreBase.setDateRange', context: context);

  @override
  Future setDateRange(PickerDateRange dt) {
    return _$setDateRangeAsyncAction.run(() => super.setDateRange(dt));
  }

  late final _$logoutAsyncAction =
      AsyncAction('HomeStoreBase.logout', context: context);

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$verifyIfIsLiveInHomeAsyncAction =
      AsyncAction('HomeStoreBase.verifyIfIsLiveInHome', context: context);

  @override
  Future verifyIfIsLiveInHome() {
    return _$verifyIfIsLiveInHomeAsyncAction
        .run(() => super.verifyIfIsLiveInHome());
  }

  late final _$getEntryRequestAsyncAction =
      AsyncAction('HomeStoreBase.getEntryRequest', context: context);

  @override
  Future getEntryRequest() {
    return _$getEntryRequestAsyncAction.run(() => super.getEntryRequest());
  }

  late final _$reloadAsyncAction =
      AsyncAction('HomeStoreBase.reload', context: context);

  @override
  Future reload() {
    return _$reloadAsyncAction.run(() => super.reload());
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  dynamic load(bool value) {
    final _$actionInfo =
        _$HomeStoreBaseActionController.startAction(name: 'HomeStoreBase.load');
    try {
      return super.load(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUseridSelected(dynamic userid) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setUseridSelected');
    try {
      return super.setUseridSelected(userid);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
selectedIndex: ${selectedIndex},
dateRange: ${dateRange},
loading: ${loading},
useridSelected: ${useridSelected},
notifications: ${notifications},
isLiveInHome: ${isLiveInHome},
usersEntryRequest: ${usersEntryRequest}
    ''';
  }
}
