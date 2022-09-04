import 'package:frontend/app/modules/auth/auth_module.dart';
import 'package:frontend/app/modules/home_registration/home_registration_module.dart';
import 'package:frontend/app/modules/spashcreen/splash_module.dart';
import 'package:frontend/app/modules/login/login_store.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/user_registration/user_registration_module.dart';
import 'package:frontend/app/modules/user_registration/user_registration_store.dart';

import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';

import 'modules/home/home_module.dart';
import 'modules/home/home_store.dart';
import 'modules/login/login_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginStore()),
    Bind.lazySingleton((i) => HomeStore()),
    Bind.lazySingleton((i) => UserRegistrationStore()),
    Bind.singleton((i) => AuthModule()),
    Bind.singleton<JwtDecodeService>((i) => JwtDecodeServiceImpl()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/user_registration', module: UserRegistrationModule()),
    ModuleRoute('/home_registration', module: HomeRegistrationModule()),
  ];
}
