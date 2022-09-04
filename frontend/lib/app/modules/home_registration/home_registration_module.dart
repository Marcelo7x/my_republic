import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home_registration/home_registration_page.dart';
import 'package:frontend/app/modules/home_registration/home_registration_store.dart';

class HomeRegistrationModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeRegistrationStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const HomeRegistrationPage(),
        transition: TransitionType.rightToLeft),
  ];
}
