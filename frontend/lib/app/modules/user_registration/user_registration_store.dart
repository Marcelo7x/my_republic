import 'package:flutter/material.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:mobx/mobx.dart';

part 'user_registration_store.g.dart';

class UserRegistrationStore = _UserRegistrationStoreBase
    with _$UserRegistrationStore;

abstract class _UserRegistrationStoreBase with Store {
  @observable
  TextEditingController firstNameController = TextEditingController();
  @observable
  TextEditingController lastNameController = TextEditingController();
  @observable
  TextEditingController homeNameController = TextEditingController();
  @observable
  TextEditingController emailController = TextEditingController();
  @observable
  TextEditingController passwordController = TextEditingController();
  @observable
  TextEditingController password2 = TextEditingController();

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
  bool userRegistrarionError = false;

  @action
  userRegistrarion() async {
    loading = true;
    try {
      await ConnectionManager.userRegistration(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text);
    } catch (e) {
      print("erro ao adicionar usuario");
      userRegistrarionError = true;
    }

    loading = false;
  }
}
