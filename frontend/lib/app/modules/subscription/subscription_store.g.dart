// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SubscriptionStore on _SubscriptionStoreBase, Store {
  late final _$nameControllerAtom =
      Atom(name: '_SubscriptionStoreBase.nameController', context: context);

  @override
  TextEditingController get nameController {
    _$nameControllerAtom.reportRead();
    return super.nameController;
  }

  @override
  set nameController(TextEditingController value) {
    _$nameControllerAtom.reportWrite(value, super.nameController, () {
      super.nameController = value;
    });
  }

  late final _$emailControllerAtom =
      Atom(name: '_SubscriptionStoreBase.emailController', context: context);

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
      Atom(name: '_SubscriptionStoreBase.passwordController', context: context);

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
      Atom(name: '_SubscriptionStoreBase.loading', context: context);

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

  late final _$subscriptionErrorAtom =
      Atom(name: '_SubscriptionStoreBase.subscriptionError', context: context);

  @override
  bool get subscriptionError {
    _$subscriptionErrorAtom.reportRead();
    return super.subscriptionError;
  }

  @override
  set subscriptionError(bool value) {
    _$subscriptionErrorAtom.reportWrite(value, super.subscriptionError, () {
      super.subscriptionError = value;
    });
  }

  late final _$_SubscriptionStoreBaseActionController =
      ActionController(name: '_SubscriptionStoreBase', context: context);

  @override
  dynamic subscription() {
    final _$actionInfo = _$_SubscriptionStoreBaseActionController.startAction(
        name: '_SubscriptionStoreBase.subscription');
    try {
      return super.subscription();
    } finally {
      _$_SubscriptionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nameController: ${nameController},
emailController: ${emailController},
passwordController: ${passwordController},
loading: ${loading},
subscriptionError: ${subscriptionError}
    ''';
  }
}
