import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'colors/color_schemes.g.dart';

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, value, child) => MaterialApp.router(
        title: 'Brothers Home',
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        themeMode: value,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
      ),
    );
  }
}
