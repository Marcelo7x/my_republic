// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$email_controllerAtom = Atom(name: '_LoginStoreBase.email_controller');

  @override
  TextEditingController get email_controller {
    _$email_controllerAtom.reportRead();
    return super.email_controller;
  }

  @override
  set email_controller(TextEditingController value) {
    _$email_controllerAtom.reportWrite(value, super.email_controller, () {
      super.email_controller = value;
    });
  }

  final _$password_controllerAtom =
      Atom(name: '_LoginStoreBase.password_controller');

  @override
  TextEditingController get password_controller {
    _$password_controllerAtom.reportRead();
    return super.password_controller;
  }

  @override
  set password_controller(TextEditingController value) {
    _$password_controllerAtom.reportWrite(value, super.password_controller, () {
      super.password_controller = value;
    });
  }

  final _$loadingAtom = Atom(name: '_LoginStoreBase.loading');

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

  final _$loggin_errorAtom = Atom(name: '_LoginStoreBase.loggin_error');

  @override
  bool get loggin_error {
    _$loggin_errorAtom.reportRead();
    return super.loggin_error;
  }

  @override
  set loggin_error(bool value) {
    _$loggin_errorAtom.reportWrite(value, super.loggin_error, () {
      super.loggin_error = value;
    });
  }

  final _$logginAsyncAction = AsyncAction('_LoginStoreBase.loggin');

  @override
  Future loggin() {
    return _$logginAsyncAction.run(() => super.loggin());
  }

  @override
  String toString() {
    return '''
email_controller: ${email_controller},
password_controller: ${password_controller},
loading: ${loading},
loggin_error: ${loggin_error}
    ''';
  }
}
