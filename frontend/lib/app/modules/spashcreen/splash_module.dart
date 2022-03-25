import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/spashcreen/splash_page.dart';
import 'package:frontend/app/modules/spashcreen/splash_store.dart';

class SplashModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashStore()),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashPage()),
  ];

}