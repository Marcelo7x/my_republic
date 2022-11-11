import 'package:flutter/material.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/home/home_store.dart';

Widget OptionsPage(
    {required BuildContext context, required HomeStore homeController}) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //header
              height: height * 0.05,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                          await homeController
                              .switchTheme(themeMode.value == ThemeMode.dark);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: width,
          height: 50,
          color: Theme.of(context).colorScheme.error,
          child: TextButton(
            child: Text(
              "Sair",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () async {
              homeController.logout();
            },
          ),
        )
      ],
    ),
  );
}
