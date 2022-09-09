import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/auth/models/auth_models.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:mobx/mobx.dart';

part 'home_registration_store.g.dart';

class HomeRegistrationStore = _HomeRegistrationStoreBase
    with _$HomeRegistrationStore;

abstract class _HomeRegistrationStoreBase with Store {
  @observable
  TextEditingController homenameSearch = TextEditingController();
  @observable
  TextEditingController homename = TextEditingController();
  @observable
  TextEditingController street = TextEditingController();
  @observable
  TextEditingController district = TextEditingController();
  @observable
  TextEditingController city = TextEditingController();
  @observable
  TextEditingController state = TextEditingController();
  @observable
  TextEditingController country = TextEditingController();
  @observable
  TextEditingController number = TextEditingController();
  @observable
  TextEditingController cep = TextEditingController();

  @observable
  bool loading = false;

  String? nameValidate(String? value) {
    String patttern = r'(^[a-zA-Z0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value == null || value.isEmpty) {
    } else if (value.contains(' ')) {
      return "O nome não pode conter espaços";
    } else if (!regExp.hasMatch(value)) {
      return "Apenas letras e números";
    }
    return null;
  }

  @observable
  bool homeRegistrarionError = false;

  @action
  homeRegistrarion() async {
    loading = true;
    final cm = Modular.get<ConnectionManager>();

    try {
      await cm.homeRegistration(
        homename: homename.text,
        street: street.text,
        district: district.text,
        city: city.text,
        state: state.text,
        country: country.text,
        number: int.parse(number.text),
        cep: int.parse(cep.text),
      );
    } catch (e) {
      print("erro ao adicionar usuario");
      homeRegistrarionError = true;
    }

    loading = false;
  }

  @action
  createHomeByName() async {
    loading = true;

    homeRegistrarionError = false;

    final cm = Modular.get<ConnectionManager>();

    try {
      var result = await cm.homeRegistration(
        homename: homename.text,
      );

      if (result != null && result.isNotEmpty) {
        findHome = true;
        homeid = result['homeid'];

        await cm.userUpadate(homeid: homeid);

        StorageLocal st = await StorageLocal.getInstance();
        Tokenization tokenization = Tokenization(
            accessToken: await st.getString('access_token') ?? '-',
            refreshToken: await st.getString('refresh_token') ?? '-');

        var t = await cm.refreshToken(tokenization.refreshToken);

        if (t != null && t.isNotEmpty) {
          await st.saveCredentials(t['access_token'], t['refresh_token']);

          Modular.to.navigate('/home/', arguments: t['access_token']);
        }
      } else {
        homeRegistrarionError = true;
      }
    } on ConnectionManagerError catch (e) {
      print("erro ao adicionar usuario");
      homeRegistrarionError = true;
    }

    loading = false;
  }

  @observable
  bool findHome = true;

  @observable
  int? homeid;

  @observable
  bool isFindingHome = false;

  @action
  setIsFindingHome(bool value) {
    isFindingHome = value;
  }

  @action
  homeSearch() async {
    loading = true;
    homeRegistrarionError = false;

    final cm = Modular.get<ConnectionManager>();

    try {
      var result = await cm.homeSearch(homenameSearch.text);

      if (result != null &&
          result.isNotEmpty &&
          result.entries.first.value is num) {
        homeid = result['homeid'];

        isFindingHome = true;

        return true;
      } else {
        homeRegistrarionError = true;
        return false;
      }
    } on ConnectionManagerError catch (e) {
      print("erro ao pesquisar home");
      homeRegistrarionError = true;
    }

    loading = false;
  }

  @action
  addHomeToUser() async {
    loading = true;
    final cm = Modular.get<ConnectionManager>();
    if (!isFindingHome || homeid == null) return;

    // try {
    //   await cm.userUpadate(homeid: homeid);
    // } on ConnectionManagerError catch (e) {
    //   homeRegistrarionError = true;
    // }

    // StorageLocal st = await StorageLocal.getInstance();
    // Tokenization tokenization = Tokenization(
    //     accessToken: await st.getString('access_token') ?? '-',
    //     refreshToken: await st.getString('refresh_token') ?? '-');

    // var t = await cm.refreshToken(tokenization.refreshToken);

    // if (t != null && t.isNotEmpty) {
    //   await st.saveCredentials(t['access_token'], t['refresh_token']);

    //   Modular.to.navigate('/home/', arguments: t['access_token']);
    // }
    if (homeid == null) {
      homeRegistrarionError = true;
      return;
    }

    try {
      await cm.entryRequest(homeid!);
      Modular.to.navigate('/login/');
    } catch (e) {
      homeRegistrarionError = true;
    }

    loading = false;
  }
}
