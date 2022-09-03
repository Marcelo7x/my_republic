import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  TextEditingController emailController = TextEditingController();
  @observable
  TextEditingController passwordController = TextEditingController();

  @observable
  bool loading = false;

  @observable
  bool logginError = false;

  @action
  loggin() async {
    loading = true;

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        final data = await ConnectionManager.login(
            emailController.text, passwordController.text);
      
        if (data.isNotEmpty && data['access_token'] != null) {
          final accessToken = data['access_token'];

          final StorageLocal conn = await StorageLocal.getInstance();
          await conn.setString('access_token', accessToken);

          Modular.to.navigate('/home/', arguments: accessToken);

        } else {
          logginError = true;
        }
      
      } on ConnectionManagerError catch (e) {
        if (e.statusCode == 403) logginError = true;
      }
      
    } else {
      logginError = true;
      print("Nao acessou");
    }

    loading = false;
  }
}
