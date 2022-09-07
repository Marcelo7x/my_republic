// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeRegistrationStore on _HomeRegistrationStoreBase, Store {
  late final _$homenameSearchAtom =
      Atom(name: '_HomeRegistrationStoreBase.homenameSearch', context: context);

  @override
  TextEditingController get homenameSearch {
    _$homenameSearchAtom.reportRead();
    return super.homenameSearch;
  }

  @override
  set homenameSearch(TextEditingController value) {
    _$homenameSearchAtom.reportWrite(value, super.homenameSearch, () {
      super.homenameSearch = value;
    });
  }

  late final _$homenameAtom =
      Atom(name: '_HomeRegistrationStoreBase.homename', context: context);

  @override
  TextEditingController get homename {
    _$homenameAtom.reportRead();
    return super.homename;
  }

  @override
  set homename(TextEditingController value) {
    _$homenameAtom.reportWrite(value, super.homename, () {
      super.homename = value;
    });
  }

  late final _$streetAtom =
      Atom(name: '_HomeRegistrationStoreBase.street', context: context);

  @override
  TextEditingController get street {
    _$streetAtom.reportRead();
    return super.street;
  }

  @override
  set street(TextEditingController value) {
    _$streetAtom.reportWrite(value, super.street, () {
      super.street = value;
    });
  }

  late final _$districtAtom =
      Atom(name: '_HomeRegistrationStoreBase.district', context: context);

  @override
  TextEditingController get district {
    _$districtAtom.reportRead();
    return super.district;
  }

  @override
  set district(TextEditingController value) {
    _$districtAtom.reportWrite(value, super.district, () {
      super.district = value;
    });
  }

  late final _$cityAtom =
      Atom(name: '_HomeRegistrationStoreBase.city', context: context);

  @override
  TextEditingController get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(TextEditingController value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  late final _$stateAtom =
      Atom(name: '_HomeRegistrationStoreBase.state', context: context);

  @override
  TextEditingController get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(TextEditingController value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$countryAtom =
      Atom(name: '_HomeRegistrationStoreBase.country', context: context);

  @override
  TextEditingController get country {
    _$countryAtom.reportRead();
    return super.country;
  }

  @override
  set country(TextEditingController value) {
    _$countryAtom.reportWrite(value, super.country, () {
      super.country = value;
    });
  }

  late final _$numberAtom =
      Atom(name: '_HomeRegistrationStoreBase.number', context: context);

  @override
  TextEditingController get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(TextEditingController value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  late final _$cepAtom =
      Atom(name: '_HomeRegistrationStoreBase.cep', context: context);

  @override
  TextEditingController get cep {
    _$cepAtom.reportRead();
    return super.cep;
  }

  @override
  set cep(TextEditingController value) {
    _$cepAtom.reportWrite(value, super.cep, () {
      super.cep = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_HomeRegistrationStoreBase.loading', context: context);

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

  late final _$homeRegistrarionErrorAtom = Atom(
      name: '_HomeRegistrationStoreBase.homeRegistrarionError',
      context: context);

  @override
  bool get homeRegistrarionError {
    _$homeRegistrarionErrorAtom.reportRead();
    return super.homeRegistrarionError;
  }

  @override
  set homeRegistrarionError(bool value) {
    _$homeRegistrarionErrorAtom.reportWrite(value, super.homeRegistrarionError,
        () {
      super.homeRegistrarionError = value;
    });
  }

  late final _$findHomeAtom =
      Atom(name: '_HomeRegistrationStoreBase.findHome', context: context);

  @override
  bool get findHome {
    _$findHomeAtom.reportRead();
    return super.findHome;
  }

  @override
  set findHome(bool value) {
    _$findHomeAtom.reportWrite(value, super.findHome, () {
      super.findHome = value;
    });
  }

  late final _$homeidAtom =
      Atom(name: '_HomeRegistrationStoreBase.homeid', context: context);

  @override
  int? get homeid {
    _$homeidAtom.reportRead();
    return super.homeid;
  }

  @override
  set homeid(int? value) {
    _$homeidAtom.reportWrite(value, super.homeid, () {
      super.homeid = value;
    });
  }

  late final _$isFindingHomeAtom =
      Atom(name: '_HomeRegistrationStoreBase.isFindingHome', context: context);

  @override
  bool get isFindingHome {
    _$isFindingHomeAtom.reportRead();
    return super.isFindingHome;
  }

  @override
  set isFindingHome(bool value) {
    _$isFindingHomeAtom.reportWrite(value, super.isFindingHome, () {
      super.isFindingHome = value;
    });
  }

  late final _$homeRegistrarionAsyncAction = AsyncAction(
      '_HomeRegistrationStoreBase.homeRegistrarion',
      context: context);

  @override
  Future homeRegistrarion() {
    return _$homeRegistrarionAsyncAction.run(() => super.homeRegistrarion());
  }

  late final _$createHomeByNameAsyncAction = AsyncAction(
      '_HomeRegistrationStoreBase.createHomeByName',
      context: context);

  @override
  Future createHomeByName() {
    return _$createHomeByNameAsyncAction.run(() => super.createHomeByName());
  }

  late final _$homeSearchAsyncAction =
      AsyncAction('_HomeRegistrationStoreBase.homeSearch', context: context);

  @override
  Future homeSearch() {
    return _$homeSearchAsyncAction.run(() => super.homeSearch());
  }

  late final _$addHomeToUserAsyncAction =
      AsyncAction('_HomeRegistrationStoreBase.addHomeToUser', context: context);

  @override
  Future addHomeToUser() {
    return _$addHomeToUserAsyncAction.run(() => super.addHomeToUser());
  }

  late final _$_HomeRegistrationStoreBaseActionController =
      ActionController(name: '_HomeRegistrationStoreBase', context: context);

  @override
  dynamic setIsFindingHome(bool value) {
    final _$actionInfo = _$_HomeRegistrationStoreBaseActionController
        .startAction(name: '_HomeRegistrationStoreBase.setIsFindingHome');
    try {
      return super.setIsFindingHome(value);
    } finally {
      _$_HomeRegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
homenameSearch: ${homenameSearch},
homename: ${homename},
street: ${street},
district: ${district},
city: ${city},
state: ${state},
country: ${country},
number: ${number},
cep: ${cep},
loading: ${loading},
homeRegistrarionError: ${homeRegistrarionError},
findHome: ${findHome},
homeid: ${homeid},
isFindingHome: ${isFindingHome}
    ''';
  }
}
