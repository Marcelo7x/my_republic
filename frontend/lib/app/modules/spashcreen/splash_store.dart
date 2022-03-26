import 'package:flutter/gestures.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:async';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  @action
  verify_login() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? logged = prefs.getBool('is_logged');

    await Future.delayed(Duration(seconds: 3));

    if (logged != null && logged) {
      Modular.to.navigate('home/');
    } else {
      Modular.to.navigate('login/');
    }
  }
}
