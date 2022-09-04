// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserRegistrationStore on _UserRegistrationStoreBase, Store {
  late final _$firstNameControllerAtom = Atom(
      name: '_UserRegistrationStoreBase.firstNameController', context: context);

  @override
  TextEditingController get firstNameController {
    _$firstNameControllerAtom.reportRead();
    return super.firstNameController;
  }

  @override
  set firstNameController(TextEditingController value) {
    _$firstNameControllerAtom.reportWrite(value, super.firstNameController, () {
      super.firstNameController = value;
    });
  }

  late final _$lastNameControllerAtom = Atom(
      name: '_UserRegistrationStoreBase.lastNameController', context: context);

  @override
  TextEditingController get lastNameController {
    _$lastNameControllerAtom.reportRead();
    return super.lastNameController;
  }

  @override
  set lastNameController(TextEditingController value) {
    _$lastNameControllerAtom.reportWrite(value, super.lastNameController, () {
      super.lastNameController = value;
    });
  }

  late final _$homeNameControllerAtom = Atom(
      name: '_UserRegistrationStoreBase.homeNameController', context: context);

  @override
  TextEditingController get homeNameController {
    _$homeNameControllerAtom.reportRead();
    return super.homeNameController;
  }

  @override
  set homeNameController(TextEditingController value) {
    _$homeNameControllerAtom.reportWrite(value, super.homeNameController, () {
      super.homeNameController = value;
    });
  }

  late final _$emailControllerAtom = Atom(
      name: '_UserRegistrationStoreBase.emailController', context: context);

  @override
  TextEditingController get emailController {
    _$emailControllerAtom.reportRead();
    return super.emailController;
  }

  @override
  set emailController(TextEditingController value) {
    _$emailControllerAtom.reportWrite(value, super.emailController, () {
      super.emailController = value;
    });
  }

  late final _$passwordControllerAtom = Atom(
      name: '_UserRegistrationStoreBase.passwordController', context: context);

  @override
  TextEditingController get passwordController {
    _$passwordControllerAtom.reportRead();
    return super.passwordController;
  }

  @override
  set passwordController(TextEditingController value) {
    _$passwordControllerAtom.reportWrite(value, super.passwordController, () {
      super.passwordController = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_UserRegistrationStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$userRegistrarionErrorAtom = Atom(
      name: '_UserRegistrationStoreBase.userRegistrarionError',
      context: context);

  @override
  bool get userRegistrarionError {
    _$userRegistrarionErrorAtom.reportRead();
    return super.userRegistrarionError;
  }

  @override
  set userRegistrarionError(bool value) {
    _$userRegistrarionErrorAtom.reportWrite(value, super.userRegistrarionError,
        () {
      super.userRegistrarionError = value;
    });
  }

  late final _$userRegistrarionAsyncAction = AsyncAction(
      '_UserRegistrationStoreBase.userRegistrarion',
      context: context);

  @override
  Future userRegistrarion() {
    return _$userRegistrarionAsyncAction.run(() => super.userRegistrarion());
  }

  @override
  String toString() {
    return '''
firstNameController: ${firstNameController},
lastNameController: ${lastNameController},
homeNameController: ${homeNameController},
emailController: ${emailController},
passwordController: ${passwordController},
loading: ${loading},
userRegistrarionError: ${userRegistrarionError}
    ''';
  }
}
