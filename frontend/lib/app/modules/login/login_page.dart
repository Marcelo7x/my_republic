import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/app/modules/login/login_store.dart';

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
      backgroundColor: Colors.black,
      body: Container(
        width: _width,
        height: _height - 100,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.network(
            //   //Logo
            //   "https://lh3.googleusercontent.com/6C7uOq_qiCVmOSkKlc1MKLYhHGoZNfXw5TpWT24YK1KH3XbLfwRbwyNioUKkZJXTBFo4zwgywVRb0Zmn9mWk-hym4Dun7WdApzjqC9m_9sv2t4aXJXNe4OyVEvJj6l2OicuhKQBsNN3wJRSKNi6Mk5zfGkVjKPlks21-ixfkEDpt8-6zYDD7galGGk26N1_ULQpRrQ_K51AAa7JCDJb--nEzPXwJ0pyk523A2Zox5lJLHSXK5FWYqBt-GUFxpLllP91NbuLmQNr_v9Rij4qYPMsiI2b44SqGSJyr4E12I-OTxJIU_9fOy2zxeLAitRAql29SQtV2hLIuk4Uaw8h076slmyd7R40FJeoo9MHsPORL8AjKI-bYjveOrsCrOKNLNT0IE9LLgKD_84stQ3TkDBuKi4KBRJICK9AB8PD9acTGykOo_TwLUYEy8PuNYKCUl7J5-8iTBENowwewplJMBw0nVli90KmH6TQTocrqABhquT_CKX9S5wGRv1B4Z0y7dV5fN6bMXOPND7NA9RCAwuNS--nsBQdWS3UDPuFsJTvdb0N76fI67TUAGPNWQGPCEPZDVmDI0RZT0uDmVKcuaeJa5aNYFn4RBpiWQl3VpOIQqboTlsQMuCFToI46IdDrpk7_p0S_sSo_DViC81lOW08rPxgb-iCJ8uqiyD89aDd_Od4yl-UuHRXleBP46Bs3EeW5FTtj2RwB5D1RqCuwyvzHyVE99YTXGUnxxZQYbzZ4Ydo3eWYQYF3Ai08L_RE=s500-no?authuser=0",
            //   height: 200, width: 200,
            // ),
            Container(
              //input de email
              width: _width * .8,
              height: 70,
              child: TextField(
                controller: controller.email_controller,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  label: Text("Senha"),
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: _width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  controller.loggin();
                  
                },
                child: const Text(
                  "Entrar",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
