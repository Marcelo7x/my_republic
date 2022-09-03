import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/auth/auth_store.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => AuthStore())
  ];
}
