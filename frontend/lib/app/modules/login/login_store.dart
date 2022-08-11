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

    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      final data = await ConnectionManager.login(
          emailController.text, passwordController.text);

      if (data.isNotEmpty) {
        final home = Home(data['homeid']);

        final user =
            User(data['userid'], 'a', home: home);

        final StorageLocal conn = await StorageLocal.getInstance();
        await conn.salveCredentials(user_id: user.id, user_name: user.name, home_id: user.home_id);

        Modular.to.navigate('/home/', arguments: {'user':user,'home':home});
      } else {
        logginError = true;
      }
    } else {
      logginError = true;
      print("Nao acessou");
    }

    loading = false;
  }
}
