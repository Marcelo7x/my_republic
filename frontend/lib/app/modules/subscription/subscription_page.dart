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
          padding: EdgeInsets.all(20),
          child: Text(
            "Cadastro",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: subscriptionController.nameController,
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Informações incorretas'),
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
