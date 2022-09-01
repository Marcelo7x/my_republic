import 'package:flutter/material.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:mobx/mobx.dart';

part 'subscription_store.g.dart';

class SubscriptionStore = _SubscriptionStoreBase with _$SubscriptionStore;

abstract class _SubscriptionStoreBase with Store {
  @observable
  TextEditingController nameController = TextEditingController();
  @observable
  TextEditingController emailController = TextEditingController();
  @observable
  TextEditingController passwordController = TextEditingController();

  @observable
  bool loading = false;

  String? nameValidate(String? value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (value == null || value.isEmpty) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String? passwordValidate(String? value) {
    String patttern = r'(^[\x21-\x7E])';
    RegExp regExp = RegExp(patttern);
    if (value == null || value.isEmpty) {
      return "Informe o celular";
    } else if (value.length < 4) {
      return "A senha deve ter no mínimo 4 carácteres";
    } else if (!regExp.hasMatch(value)) {
      return "A senha deve ter no mínimo 4 carácteres contendo números ou letras";
    }
    return null;
  }

  String? emailValidate(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }
  
  @observable
  bool subscriptionError = false;

  @action
  subscription() {
    loading = true;
    try {
      ConnectionManager.subscription(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text);
    } catch (e) {
      print("erro ao adicionar usuario");
      subscriptionError = true;
    }

    loading = false;
  }

  @action
  createHome() {
    loading = true;
    try {
      ConnectionManager.createHome(
          name: nameController.text
        );
    } catch (e) {
      print("erro ao criar ou entrar na republica");
      subscriptionError = true;
    }

    loading = false;
  }
}
