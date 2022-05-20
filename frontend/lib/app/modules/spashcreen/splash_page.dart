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
      await store.verify_theme();
    }

    initState();

    var logo = AssetImage("images/logo.png");

    return Container(
      //color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.fill, image: logo)),
            ),
          ),
          Observer(builder: (_) {
            return controller.error
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      controller.erro_menssage,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.error,
                          decoration: TextDecoration.none),
                    ),
                  )
                : const CircularProgressIndicator();
          }),
        ],
      ),
    );
  }
}
