// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStoreBase, Store {
  late final _$emailControllerAtom =
      Atom(name: '_LoginStoreBase.emailController', context: context);

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

  late final _$passwordControllerAtom =
      Atom(name: '_LoginStoreBase.passwordController', context: context);

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
      Atom(name: '_LoginStoreBase.loading', context: context);

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

  late final _$logginErrorAtom =
      Atom(name: '_LoginStoreBase.logginError', context: context);

  @override
  bool get logginError {
    _$logginErrorAtom.reportRead();
    return super.logginError;
  }

  @override
  set logginError(bool value) {
    _$logginErrorAtom.reportWrite(value, super.logginError, () {
      super.logginError = value;
    });
  }

  late final _$logginAsyncAction =
      AsyncAction('_LoginStoreBase.loggin', context: context);

  @override
  Future loggin() {
    return _$logginAsyncAction.run(() => super.loggin());
  }

  @override
  String toString() {
    return '''
emailController: ${emailController},
passwordController: ${passwordController},
loading: ${loading},
logginError: ${logginError}
    ''';
  }
}
