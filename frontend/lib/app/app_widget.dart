import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brothers Home',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
      ),
    ).modular();
  }
}