import 'package:frontend/app/modules/auth/models/auth_models.dart';

abstract class AuthState {}

class Inprocess extends AuthState {}

class Logged extends AuthState {
  final Tokenization tokenization;
  Logged(this.tokenization);
}

class Unlogged extends AuthState {}
