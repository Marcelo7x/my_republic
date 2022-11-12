import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/home/widget/selectRageDate_popup.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //header
              height: height * 0.05,
              width: width,
              margin: const EdgeInsets.only(top: 20),
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
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Alterar período   ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SelectDateInterval(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tema Escuro",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    child: Switch(
                        value: themeModeAndColor.value['thememode'] ==
                            ThemeMode.dark,
                        //child: const Text("Trocar tema"),
                        onChanged: (isDark) async {
                          themeModeAndColor.value['thememode'] =
                              isDark ? ThemeMode.dark : ThemeMode.light;
                          await homeController.switchTheme(
                              themeModeAndColor.value['thememode'] ==
                                  ThemeMode.dark);
                          themeModeAndColor.notifyListeners();
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Cor de Destaque",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ColorPicker(
                // Use the screenPickerColor as start color.
                color: themeModeAndColor.value['color'],
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.both: false,
                  ColorPickerType.primary: true,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
                  ColorPickerType.custom: false,
                  ColorPickerType.wheel: false,
                },
                enableShadesSelection: false,
                // Update the themeModeAndColor using the callback.
                onColorChanged: (Color color) {
                  themeModeAndColor.value['color'] = color;
                  homeController.switchColor(color);
                  themeModeAndColor.notifyListeners();
                },
                width: 44,
                height: 44,
                borderRadius: 22,
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
