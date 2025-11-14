import 'package:meta/meta.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String uid;

  LoginSuccess(this.uid);
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class ChangePasswwordState extends LoginState {}
