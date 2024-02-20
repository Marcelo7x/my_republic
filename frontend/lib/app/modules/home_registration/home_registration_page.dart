// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/app/app_widget.dart';
import 'package:frontend/app/modules/home_registration/home_registration_store.dart';

class HomeRegistrationPage extends StatefulWidget {
  const HomeRegistrationPage({Key? key}) : super(key: key);

  @override
  _HomeRegistrationPageState createState() => _HomeRegistrationPageState();
}

class _HomeRegistrationPageState extends State<HomeRegistrationPage> {
  final homeRegistrarionController = Modular.get<HomeRegistrationStore>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: GestureDetector(
          onTap: () {
            Modular.to.navigate('/login/');
          },
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
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: width * .7,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 150, bottom: 30),
                              child: Text(
                                "Entrar para República",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width * .75,
                        padding: const EdgeInsets.only(bottom: 15, right: 10),
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            controller:
                                homeRegistrarionController.homenameSearch,
                            validator: (value) =>
                                homeRegistrarionController.nameValidate(value),
                            decoration: const InputDecoration(
                              label: Text(
                                "Encontrar república",
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            maxLength: 40,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            padding: const EdgeInsets.only(right: 20),
                            child: Observer(builder: (_) {
                              return FilledButton(
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      18.0,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (homeRegistrarionController
                                      .homenameSearch.text.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pesquisando...'),
                                        duration: Duration(seconds: 90),
                                      ),
                                    );
                                    if (await homeRegistrarionController
                                            .homeSearch() ??
                                        false == false) {
                                      if (homeRegistrarionController
                                          .homeRegistrarionError) {
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Erro!!! República não encontrada ou falha na rede'),
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ));

                                        homeRegistrarionController
                                            .homeRegistrarionError = false;
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            elevation: 1000,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            title: Text(
                                                'Entrar para a República ${homeRegistrarionController.homenameSearch.text}?'),
                                            content: const Text(
                                                'Um pedido de entrada será enviado para o criador da república.'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text("Adicionar"),
                                                onPressed: () async {
                                                  await homeRegistrarionController
                                                      .addHomeToUser();

                                                  if (homeRegistrarionController
                                                      .homeRegistrarionError) {
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .removeCurrentSnackBar();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content:
                                                          const Text('Erro!!!'),
                                                      duration: const Duration(
                                                          seconds: 5),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .error,
                                                    ));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .removeCurrentSnackBar();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: const Text(
                                                          "Pedido enviado"),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ));
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    // Modular.to.pop();
                                                  }
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const Text('Pesquisar',
                                    style: TextStyle(fontSize: 16)),
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: _formUI(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUI(context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width * .7,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 70, bottom: 30),
                child: Text(
                  "Cadastrar República",
                  style: TextStyle(
                    fontSize: 25,
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
            controller: homeRegistrarionController.homename,
            decoration: const InputDecoration(
              label: Text(
                "Nome da República",
              ),
              prefixIcon: Icon(Icons.home),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
            ),
            keyboardType: TextInputType.name,
            maxLength: 40,
            validator: (value) =>
                homeRegistrarionController.nameValidate(value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: Observer(builder: (_) {
                return FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        18.0,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Carregando...'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      await homeRegistrarionController.createHomeByName();
                      if (homeRegistrarionController.homeRegistrarionError) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Erro de conexão...'),
                          duration: const Duration(seconds: 5),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Cadastrado com sucesso!"),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          duration: const Duration(seconds: 3),
                        ));
                        await Future.delayed(const Duration(seconds: 2));
                        //Modular.to.pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Informações incorretas'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                    // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  },
                  child:
                      const Text('Cadastrar', style: TextStyle(fontSize: 16)),
                );
              }),
            ),
          ],
        )
      ],
    );
  }
}
