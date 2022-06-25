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

  late final _$erroMenssageAtom =
      Atom(name: '_SplashStoreBase.erroMenssage', context: context);

  @override
  String get erroMenssage {
    _$erroMenssageAtom.reportRead();
    return super.erroMenssage;
  }

  @override
  set erroMenssage(String value) {
    _$erroMenssageAtom.reportWrite(value, super.erroMenssage, () {
      super.erroMenssage = value;
    });
  }

  late final _$darkThemeAtom =
      Atom(name: '_SplashStoreBase.darkTheme', context: context);

  @override
  bool get darkTheme {
    _$darkThemeAtom.reportRead();
    return super.darkTheme;
  }

  @override
  set darkTheme(bool value) {
    _$darkThemeAtom.reportWrite(value, super.darkTheme, () {
      super.darkTheme = value;
    });
  }

  late final _$verifyThemeAsyncAction =
      AsyncAction('_SplashStoreBase.verifyTheme', context: context);

  @override
  Future verifyTheme() {
    return _$verifyThemeAsyncAction.run(() => super.verifyTheme());
  }

  late final _$verifyLoginAsyncAction =
      AsyncAction('_SplashStoreBase.verifyLogin', context: context);

  @override
  Future verifyLogin() {
    return _$verifyLoginAsyncAction.run(() => super.verifyLogin());
  }

  @override
  String toString() {
    return '''
error: ${error},
erroMenssage: ${erroMenssage},
darkTheme: ${darkTheme}
    ''';
  }
}
