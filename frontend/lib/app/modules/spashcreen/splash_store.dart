import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/app_module.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/auth/models/auth_models.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:frontend/domain/user.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  final String version = '0.0.7';

  @observable
  bool error = false;

  @observable
  String erroMenssage = "";

  @observable
  bool darkTheme = false;

  @action
  verifyTheme() async {
    final StorageLocal prefs = await StorageLocal.getInstance();

    bool? isDarkTheme = prefs.connection.getBool('is_dark_theme');

    if (isDarkTheme != null && isDarkTheme) {
      themeModeAndColor.value['thememode'] = ThemeMode.dark;
    }

    int? colorTheme = prefs.connection.getInt('color_theme');
    themeModeAndColor.value['color'] = Color(colorTheme ?? 0xff2196f3);
    print(colorTheme);

    themeModeAndColor.notifyListeners();
  }

  verifyVersion(final String v) {
    final v1 = version.split('.');
    final v2 = v.split('.');

    for (var i = 0; i < v2.length; i++) {
      if (int.parse(v1[i]) < int.parse(v2[i])) {
        erroMenssage =
            "O App está desatualizado!\nAtulize-o e tente novamente.";
        error = true;
      }
    }
  }

  @action
  verifyLogin() async {
    var result;
    await Modular.isModuleReady<AppModule>();
    final cm = Modular.get<ConnectionManager>();
    try {
      result = await cm.verify_server();
    } on Exception catch (e) {
      error = true;
      erroMenssage = "O servidor está desligado, tente voltar daqui a pouco.";
    }

    Tokenization? tokenization;
    if (!error) verifyVersion(result["force_update"]);

    if (!error) {
      final StorageLocal conn = await StorageLocal.getInstance();
      final String? accessToken = await conn.getString('access_token');
      final String? refreshToken = await conn.getString('refresh_token');

      bool logged = false;
      if (accessToken != null && refreshToken != null) {
        try {
          final keys = await cm.refreshToken(refreshToken);
          if (keys['access_token'] != null &&
              (keys['access_token'] as String).isNotEmpty) {
            tokenization = Tokenization(
                accessToken: keys['access_token'],
                refreshToken: keys['refresh_token']);
            conn.saveCredentials(
                tokenization.accessToken, tokenization.refreshToken);
            logged = true;
          }
        } on ConnectionManagerError catch (e) {
          Modular.to.navigate('/login/');
          return;
        }
      }

      if (logged && tokenization != null) {
        JwtDecodeService jwt = Modular.get<JwtDecodeService>();
        final payload = jwt.getPayload(tokenization.accessToken);

        // TODO: NoHomePage route

        if (payload['homeid'].runtimeType == Null) {
          try {
            final existRequest = await cm.getEntryRequest();

            if (existRequest) {
              Modular.to
                  .navigate('/home/', arguments: tokenization.accessToken);
              return;
            }
          } on ConnectionManagerError catch (e) {}

          Modular.to.navigate('/home_registration',
              arguments: tokenization.accessToken);
        } else {
          Modular.to.navigate('/home/', arguments: tokenization.accessToken);
        }
      } else {
        Modular.to.navigate('/login/');
      }
    }
  }
}
