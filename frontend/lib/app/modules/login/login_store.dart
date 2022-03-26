import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';

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

    await Future.delayed(Duration(seconds: 2));

    if (email_controller.text.length > 0 &&
        password_controller.text.length > 0) {
      try {
        var response = await Dio().get('http://192.168.1.9:8080/list-users');
        print(response);
      } catch (e) {
        print(e);
      }
    } else {
      loggin_error = true;
      print("Nao acessou");
    }

    loading = false;
  }
}
