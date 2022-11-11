import 'package:flutter/material.dart';

class NoHomePage extends StatefulWidget {
  const NoHomePage({Key? key}) : super(key: key);

  @override
  State<NoHomePage> createState() => _NoHomePageState();
}

class _NoHomePageState extends State<NoHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //header
            alignment: Alignment.center,
            height: height * 0.05,
            width: width,
            child: const Text(
              "Bem vindo ao MY REPUBLIC",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            height: height * 0.05,
            child: const Text(
              'Sua solicitação foi envida, aguarde a confirmação da república.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
