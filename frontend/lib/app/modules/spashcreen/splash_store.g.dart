// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashStore on _SplashStoreBase, Store {
  late final _$errorAtom =
      Atom(name: '_SplashStoreBase.error', context: context);

  @override
  bool get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(bool value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$erro_menssageAtom =
      Atom(name: '_SplashStoreBase.erro_menssage', context: context);

  @override
  String get erro_menssage {
    _$erro_menssageAtom.reportRead();
    return super.erro_menssage;
  }

  @override
  set erro_menssage(String value) {
    _$erro_menssageAtom.reportWrite(value, super.erro_menssage, () {
      super.erro_menssage = value;
    });
  }

  late final _$verify_loginAsyncAction =
      AsyncAction('_SplashStoreBase.verify_login', context: context);

  @override
  Future verify_login() {
    return _$verify_loginAsyncAction.run(() => super.verify_login());
  }

  @override
  String toString() {
    return '''
error: ${error},
erro_menssage: ${erro_menssage}
    ''';
  }
}
