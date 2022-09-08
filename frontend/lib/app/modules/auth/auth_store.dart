import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/auth/errors/auth_errors.dart';
import 'package:frontend/app/modules/auth/models/auth_models.dart';
import 'package:frontend/app/modules/auth/state/auth_states.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  @observable
  AuthState authState = Inprocess();

  @action
  Future<void> login(email, password) async {
    final cm = Modular.get<ConnectionManager>();

    try {
      final result = await cm.login(email, password);
      Tokenization tokenization = Tokenization.fromMap(result);

      authState = Logged(tokenization);
    } on Exception catch (e, s) {
      throw AuthException(e.toString(), s);
    }
  }
}
