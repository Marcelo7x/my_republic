import 'package:flutter/material.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/home/home_store.dart';

Widget OptionsPage(
    {required BuildContext context, required HomeStore homeController}) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Column(
      children: [
        SizedBox(
          //header
          height: height * 0.1,
          width: width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.settings),
                  Text(
                    "Configurações",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.75,
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
                          onChanged: (isDark) async {
                            themeMode.value =
                                isDark ? ThemeMode.dark : ThemeMode.light;
                            await homeController.switch_theme(
                                themeMode.value == ThemeMode.dark);
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
                      homeController.logout();
                    }),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
