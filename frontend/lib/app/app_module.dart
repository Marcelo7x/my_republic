import 'package:frontend/app/modules/auth/auth_module.dart';
import 'package:frontend/app/modules/spashcreen/splash_module.dart';
import 'package:frontend/app/modules/login/login_store.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/subscription/subscription_module.dart';
import 'package:frontend/app/modules/subscription/subscription_store.dart';
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
    Bind.lazySingleton((i) => SubscriptionStore()),
    Bind.singleton((i) => AuthModule()),
    Bind.singleton<JwtDecodeService>((i) => JwtDecodeServiceImpl()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/subscription', module: SubscriptionModule()),
  ];
}
