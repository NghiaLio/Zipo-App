// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/userModels.dart';

class UserState extends Equatable {
  final UserApp? userApp;
  final List<UserApp> listFriends;
  final bool isLoading;
  final String? error;

  const UserState({
    this.userApp,
    this.listFriends = const [],
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserApp? userApp,
    List<UserApp>? listFriends,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      userApp: userApp ?? this.userApp,
      listFriends: listFriends ?? this.listFriends,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [userApp, listFriends, isLoading, error];
}
