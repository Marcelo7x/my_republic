import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/spashcreen/splash_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashStore> {
  @override
  Widget build(BuildContext context) {
    initState() async {
      await store.verify_login();
    }

    initState();

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "https://sonhoastral.com/uploads/article/image/1993/card_C%C3%B3pia_de_casa_caindo.jpg"))),
            ),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
