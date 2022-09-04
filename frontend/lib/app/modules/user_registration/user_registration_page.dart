import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/app/modules/user_registration/user_registration_store.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final userRegistrarionController = Modular.get<UserRegistrationStore>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: GestureDetector(
          onTap: () => Modular.to.pop(),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            RotatedBox(
              quarterTurns: -45,
              child: SizedBox(
                // width: 100,
                width: height,
                height: width * .35,
                child: SvgPicture.asset(
                  'images/wave2.svg',
                  alignment: Alignment.topRight,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: _formUI(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUI(context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: width * .7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 80, bottom: 90),
                child: Text(
                  "Cadastro",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: width * .8,
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: userRegistrarionController.firstNameController,
            decoration: const InputDecoration(
              label: Text(
                "Nome",
              ),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
            keyboardType: TextInputType.name,
            maxLength: 40,
            validator: (value) =>
                userRegistrarionController.nameValidate(value),
          ),
        ),
        Container(
          width: width * .8,
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: userRegistrarionController.lastNameController,
            decoration: const InputDecoration(
              label: Text("Sobrenome"),
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
            keyboardType: TextInputType.name,
            maxLength: 40,
            validator: (value) =>
                userRegistrarionController.nameValidate(value),
          ),
        ),
        Container(
          width: width * .8,
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: userRegistrarionController.emailController,
            decoration: const InputDecoration(
              label: Text("Email"),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            maxLength: 40,
            validator: (value) =>
                userRegistrarionController.emailValidate(value),
          ),
        ),
        Container(
          width: width * .8,
          padding: const EdgeInsets.only(bottom: 15),
          child: TextFormField(
            controller: userRegistrarionController.passwordController,
            decoration: const InputDecoration(
              label: Text("Senha"),
              prefixIcon: Icon(Icons.password),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            maxLength: 100,
            validator: (value) =>
                userRegistrarionController.passwordValidate(value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 70,
              padding: const EdgeInsets.only(top: 15),
              child: Observer(builder: (_) {
                return ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Carregando...'),
                          duration: Duration(seconds: 90),
                        ),
                      );
                      await userRegistrarionController.userRegistrarion();
                      if (userRegistrarionController.userRegistrarionError) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Erro de conexão...'),
                          duration: const Duration(seconds: 5),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Cadastrado com sucesso!"),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          duration: const Duration(seconds: 2),
                        ));
                        await Future.delayed(const Duration(seconds: 1));
                        Modular.to.pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Informações incorretas'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  },
                  child: const Text('Cadastrar'),
                );
              }),
            ),
          ],
        )
      ],
    );
  }
}
