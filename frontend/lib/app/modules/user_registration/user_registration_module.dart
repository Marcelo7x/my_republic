import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/user_registration/user_registration_page.dart';
import 'package:frontend/app/modules/user_registration/user_registration_store.dart';

class UserRegistrationModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => UserRegistrationStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => const UserRegistrationPage(),
        transition: TransitionType.rightToLeft),
  ];
}
