// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterEvent(this.name, this.email, this.password);

  @override
  List<Object?> get props => [name, email, password];
}

class LogoutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class CheckAuthEvent extends AuthEvent {}