import 'package:flutter/material.dart';
import 'package:frontend/app/modules/home/home_store.dart';

Widget OptionsPage(
    {required BuildContext context, required HomeStore controller}) {
  return SafeArea(
    child: Column(
      children: [
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
  );
}
