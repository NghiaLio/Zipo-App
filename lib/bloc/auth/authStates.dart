// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

import '../../models/userModels.dart';

class AuthState extends Equatable {
  final UserApp? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? message;
  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.message,
  });

  AuthState copyWith({
    UserApp? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? message,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, isAuthenticated, message];
}
