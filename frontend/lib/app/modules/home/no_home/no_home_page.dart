import 'package:flutter/material.dart';

class NoHomePage extends StatefulWidget {
  const NoHomePage({Key? key}) : super(key: key);

  @override
  State<NoHomePage> createState() => _NoHomePageState();
}

class _NoHomePageState extends State<NoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text('Bem Vindo(a) ao MY REPUBLIC.'),
          ),
          Center(
            child: Text(
                'Sua solicitação foi envida, aguarde a confirmação da república.'),
          ),
        ],
      ),
    );
  }
}
