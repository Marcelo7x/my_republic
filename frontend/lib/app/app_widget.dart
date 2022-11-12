import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'colors/color_schemes.g.dart';

ValueNotifier<Map<String, dynamic>> themeModeAndColor = ValueNotifier({'thememode': ThemeMode.light, 'color':Color(0xff2196f3)});
// ValueNotifier<Color> screenPickerColor = ValueNotifier(Color(0xff2196f3));

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, dynamic>>(
      valueListenable: themeModeAndColor,
      builder: (context, value, child) => MaterialApp.router(
        title: 'Brothers Home',
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        themeMode: value['thememode'],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: value['color'],
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: value['color'],
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
