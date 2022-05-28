import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  final String version = '0.0.4';
  final String url = 'http://192.168.1.9:8080/';

  @observable
  bool error = false;

  @observable
  String erro_menssage = "";

  @observable
  bool dark_theme = false;

  @action
  verify_theme() async {
    final StorageLocal prefs = await StorageLocal.getInstance();

    bool? is_dark_theme = prefs.connection.getBool('is_dark_theme');

    if (is_dark_theme != null && is_dark_theme) {
      themeMode.value = ThemeMode.dark;
    }
  }

  verify_version(final String v) {
    final v1 = version.split('.');
    final v2 = v.split('.');

    for (var i = 0; i < v2.length; i++) {
      if (int.parse(v1[i]) < int.parse(v2[i])) {
        erro_menssage =
            "O App está desatualizado!\nAtulize-o e tente novamente.";
        error = true;
      }
    }
  }

  @action
  verify_login() async {
    var result;
    try {
      result = await ConnectionManager.verify_server();
    } on Exception catch (e) {
      error = true;
      erro_menssage = "O servidor está desligado, tente voltar daqui a pouco.";
    }

    if (!error) verify_version(result["force_update"]);

    if (!error) {
      final StorageLocal conn = await StorageLocal.getInstance();
      Map<String, dynamic> data = await conn.verify_credentials();

      if (data.length > 0) {
        Home home = Home(data['home_id']);
        User user = User(data['user_id'], data['user_name'], home: home);

        Modular.to.navigate('/home', arguments: {'user': user, 'home': home});
      } else {
        Modular.to.navigate('/login');
      }
    }
  }
}
