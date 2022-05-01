import 'package:flutter/gestures.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:async';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  @action
  verify_login() async {
    Permission.storage.request();

    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool('is_logged');

    await Future.delayed(Duration(seconds: 1));

    //logged = false;

    if (logged != null && logged) {
      int? id = await prefs.getInt('id');
      Modular.to.navigate('home/', arguments: id);
    } else {
      Modular.to.navigate('login/');
    }
  }
}
