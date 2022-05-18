import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/login/login_store.dart';
import 'package:mobx/mobx.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginStore> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        width: _width,
        height: _height - 100,
        //color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.png", height: 200, width: 200),
            SizedBox(
              //input de email
              width: _width * .8,
              height: 70,
              child: TextField(
                controller: controller.email_controller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              //input senha
              width: _width * .8,
              height: 70,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: TextField(
                controller: controller.password_controller,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Senha"),
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  controller.loggin();
                },
                child: Observer(builder: (_) {
                  return !controller.loading
                      ? const Text(
                          "Entrar",
                        )
                      : const CircularProgressIndicator(color: Colors.white);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Observer(builder: (_) {
                return controller.loggin_error
                    ? Text(
                        "Ô cabaço!! O email ou senha está errado.",
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      )
                    : const Text("");
              }),
            ),
          ],
        ),
      ),
    );
  }
}
