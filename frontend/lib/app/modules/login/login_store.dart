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
  TextEditingController email_controller = TextEditingController();
  @observable
  TextEditingController password_controller = TextEditingController();

  @observable
  bool loading = false;

  @observable
  bool loggin_error = false;

  @action
  loggin() async {
    loading = true;

    if (email_controller.text.isNotEmpty &&
        password_controller.text.isNotEmpty) {
      final data = await ConnectionManager.login(
          email_controller.text, password_controller.text);

      if (data.length > 0) {
        final home = Home(data['users']['homeid']);

        final user =
            User(data['users']['userid'], 'a', home: home);

        final StorageLocal conn = await StorageLocal.getInstance();
        await conn.salve_credentials(user_id: user.id, user_name: user.name, home_id: user.home_id);

        Modular.to.navigate('/home/', arguments: {'user':user,'home':home});
      } else {
        loggin_error = true;
      }
    } else {
      loggin_error = true;
      print("Nao acessou");
    }

    loading = false;
  }
}
