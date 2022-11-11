import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/app/modules/login/login_store.dart';

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
        child: Stack(
          children: [
            // SizedBox(
            //   height: height,
            //   width: width,
            //   child: RotatedBox(
            //     quarterTurns: 45,
            //     child: SvgPicture.asset(
            //       'images/wave.svg',
            //       alignment: Alignment.topRight,
            //       fit: BoxFit.fitWidth,
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: height,
                  width: 150,
                  child: RotatedBox(
                    quarterTurns: 45,
                    child: SvgPicture.asset(
                      'images/wave.svg',
                      alignment: Alignment.topRight,
                      fit: BoxFit.fill,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image.asset("images/logo.png", height: 200, width: 200),
                  Container(
                    margin: const EdgeInsets.only(top: 80, bottom: 30),
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/logo.png"),
                          invertColors: false),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        //input de email
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: width * .9,
                        height: 70,
                        alignment: Alignment.center,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(' ',
                                replacementString: '')
                          ],
                          controller: loginController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        //input senha
                        width: width * .9,
                        height: 70,
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(15)),
                        child: Observer(builder: (context) {
                          return TextField(
                            controller: loginController.passwordController,
                            obscureText:
                                loginController.visibility ? false : true,
                            decoration: InputDecoration(
                                hintText: "Senha",
                                prefixIcon: Icon(Icons.password),
                                border: InputBorder.none,
                                suffixIcon: GestureDetector(
                                  onTap: () =>
                                      loginController.alterVisibility(),
                                  child: Observer(builder: (_) {
                                    return Icon(
                                      loginController.visibility
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    );
                                  }),
                                )),
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * .65,
                            // margin: const EdgeInsets.only(right: 100),
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * .5,
                            height: 50,
                            margin: const EdgeInsets.only(right: 70),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15)),
                            child: TextButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                loginController.loggin();
                              },
                              child: Observer(builder: (_) {
                                return !loginController.loading
                                    ? Text(
                                        "Entrar",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white);
                              }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: width * .82,
                              child: TextButton(
                                  onPressed: () => Modular.to
                                      .pushNamed('/user_registration/'),
                                  child: const Text("Cadastre-se"))),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     SizedBox(
            //       height: height,
            //       width: 150,
            //       child: RotatedBox(
            //         quarterTurns: 45,
            //         child: SvgPicture.asset(
            //           'images/wave.svg',
            //           alignment: Alignment.topRight,
            //           fit: BoxFit.fill,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
