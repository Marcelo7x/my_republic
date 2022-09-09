import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoHomePage extends StatefulWidget {
  const NoHomePage({Key? key}) : super(key: key);

  @override
  State<NoHomePage> createState() => _NoHomePageState();
}

class _NoHomePageState extends State<NoHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Aguardando confirmação da república'),),
    );
  }
}
