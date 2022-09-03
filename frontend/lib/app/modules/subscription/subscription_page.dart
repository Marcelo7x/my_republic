import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/subscription/subscription_store.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final subscriptionController = Modular.get<SubscriptionStore>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  Padding(
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
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: _formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 40),
          child: Text(
            "Cadastro",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: subscriptionController.firstNameController,
          decoration: const InputDecoration(
            label: Text("Nome"),
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
          ),
          keyboardType: TextInputType.name,
          maxLength: 40,
          validator: (value) => subscriptionController.nameValidate(value),
        ),
        TextFormField(
          controller: subscriptionController.lastNameController,
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
          validator: (value) => subscriptionController.nameValidate(value),
        ),
        TextFormField(
          controller: subscriptionController.emailController,
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
          validator: (value) => subscriptionController.emailValidate(value),
        ),
        const SizedBox(height: 15.0),
        TextFormField(
          controller: subscriptionController.passwordController,
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
          validator: (value) => subscriptionController.passwordValidate(value),
        ),
        Padding(
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
                  await subscriptionController.subscription();
                  if (subscriptionController.subscriptionError) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Erro de conexão...'),
                      duration: const Duration(seconds: 5),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Cadastrado com sucesso!"),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
        )
      ],
    );
  }
}
