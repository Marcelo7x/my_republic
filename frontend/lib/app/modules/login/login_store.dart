import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';
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

  @observable
  bool visibility = false;

  @action
  alterVisibility() {
    visibility = !visibility;
  }

  @action
  loggin() async {
    loading = true;
    final cm = Modular.get<ConnectionManager>();

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        final data =
            await cm.login(emailController.text, passwordController.text);

        if (data.isNotEmpty && data['access_token'] != null) {
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];

          final StorageLocal conn = await StorageLocal.getInstance();
          conn.saveCredentials(accessToken, refreshToken);

          JwtDecodeService jwt = Modular.get<JwtDecodeService>();
          final payload = jwt.getPayload(accessToken);

          await cm.initApiClient();

          if (payload['homeid'].runtimeType == Null) {
            try {
              final existRequest = await cm.getEntryRequest();

              if (existRequest) {
                Modular.to.navigate('/home/', arguments: accessToken);

                return;
              }
            } on ConnectionManagerError catch (e) {}

            Modular.to.navigate('/home_registration', arguments: accessToken);
          } else {
            Modular.to.navigate('/home/', arguments: accessToken);
          }
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
