import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/subscription/subscription_page.dart';
import 'package:frontend/app/modules/subscription/subscription_store.dart';

class SubscriptionModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SubscriptionStore()),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) =>  const SubscriptionPage(), transition: TransitionType.rightToLeft),

  ];

}