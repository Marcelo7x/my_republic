import 'package:flutter/material.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/home/home_store.dart';

Widget OptionsPage(
    {required BuildContext context, required HomeStore controller}) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  bool theme_selected = true;

  return SafeArea(
    child: Column(
      children: [
        SizedBox(
          //header
          height: _height * 0.1,
          width: _width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.settings),
                  Text(
                    "Configurações",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: _height * 0.75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Tema Escuro",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      child: Switch(
                          value: themeMode.value == ThemeMode.dark,
                          //child: const Text("Trocar tema"),
                          onChanged: (isDark) {
                            themeMode.value =
                                isDark ? ThemeMode.dark : ThemeMode.light;
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    child: const Text("Sair"),
                    onPressed: () {
                      controller.logout();
                    }),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
