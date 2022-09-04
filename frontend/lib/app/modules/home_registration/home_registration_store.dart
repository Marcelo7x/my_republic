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
      return "Digite um nome";
    } else if (value.contains(' ')) {
      return "O nome não pode conter espaços";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter apenas letras e números";
    }
    return null;
  }

  @observable
  bool homeRegistrarionError = false;

  @action
  homeRegistrarion() async {
    loading = true;
    try {
      await ConnectionManager.homeRegistration(
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
    try {
      await ConnectionManager.initApiClient();
      var result = await ConnectionManager.homeRegistration(
        homename: homename.text,
      );

      if (result != null) {
        findHome = true;
        homeid = result['homeid'];

        await ConnectionManager.userUpadate(homeid: homeid);

        StorageLocal st = await StorageLocal.getInstance();
        Tokenization tokenization = Tokenization(
            accessToken: await st.getString('access_token') ?? '-',
            refreshToken: await st.getString('refresh_token') ?? '-');

        var t = await ConnectionManager.refreshToken(tokenization.refreshToken);

        if (t != null && t.isNotEmpty) {
          await st.saveCredentials(t['access_token'], t['refresh_token']);

          Modular.to.navigate('/home/', arguments: t['access_token']);
        }
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

  @action
  homeSearch() async {
    loading = true;
    homeRegistrarionError = false;

    await ConnectionManager.initApiClient();

    try {
      var result = await ConnectionManager.homeSearch(homenameSearch.text);

      if (result != null && result.isNotEmpty) {
        findHome = true;
        homeid = result['homeid'];

        await ConnectionManager.userUpadate(homeid: homeid);

        StorageLocal st = await StorageLocal.getInstance();
        Tokenization tokenization = Tokenization(
            accessToken: await st.getString('access_token') ?? '-',
            refreshToken: await st.getString('refresh_token') ?? '-');

        var t = await ConnectionManager.refreshToken(tokenization.refreshToken);

        if (t != null && t.isNotEmpty) {
          await st.saveCredentials(t['access_token'], t['refresh_token']);

          Modular.to.navigate('/home/', arguments: t['access_token']);
        }
      } else {
        findHome = false;
        homeRegistrarionError = true;
      }
    } on ConnectionManagerError catch (e) {
      print("erro ao pesquisar home");
      homeRegistrarionError = true;
    }

    loading = false;
  }
}
