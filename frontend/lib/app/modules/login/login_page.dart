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

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final LoginStore loginController = Modular.get<LoginStore>();

    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        //color: Theme.of(context).backgroundColor,
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image.asset("images/logo.png", height: 200, width: 200),
              const Padding(
                padding: EdgeInsets.only(top: 80, bottom: 30),
                child: Icon(
                  Icons.home_rounded,
                  size: 200,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    //input de email
                    width: width * .8,
                    height: 70,
                    child: TextField(
                      controller: loginController.emailController,
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
                    width: width * .8,
                    height: 70,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: TextField(
                      controller: loginController.passwordController,
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
                  Container(
                    //margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: Observer(builder: (_) {
                      return loginController.logginError
                          ? Text(
                              "O email ou senha está errado.",
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            )
                          : const Text("");
                    }),
                  ),
                  SizedBox(
                    width: width * .8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        loginController.loggin();
                      },
                      child: Observer(builder: (_) {
                        return !loginController.loading
                            ? const Text(
                                "Entrar",
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white);
                      }),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () =>
                              Modular.to.pushNamed('/subscription/'),
                          child: const Text("Cadastre-se")))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
