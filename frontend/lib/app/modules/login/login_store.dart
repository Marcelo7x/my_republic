import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

    String url = await SharedPreferences.getInstance().then((value) => value.getString('url')!);

    if (email_controller.text.length > 0 &&
        password_controller.text.length > 0) {
      
      try {
        var response = await Dio().post(url+'login',
            data: jsonEncode([
              {
                "email": email_controller.text.replaceAll(RegExp(r' '), ''),
                "password": password_controller.text
              }
            ]));

        if (jsonDecode(response.data).length > 0) {
          var id = jsonDecode(response.data)[0]['users']['userid'];
          var homeid = jsonDecode(response.data)[0]['users']['homeid'];
          final prefs = await SharedPreferences.getInstance();

          await prefs.setInt('id', id);
          await prefs.setInt('home_id', homeid);
          await prefs.setBool('is_logged', true);

          Modular.to.navigate('/home/', arguments: id);
        } else {
          loggin_error = true;
        }
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
