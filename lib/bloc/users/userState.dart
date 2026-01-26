// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/userModels.dart';

class UserState extends Equatable {
  final UserApp? userApp;
  final List<UserApp> listFriends;
  final List<UserApp> listFriendRequests;
  final bool isLoading;
  final String? error;

  const UserState({
    this.userApp,
    this.listFriends = const [],
    this.listFriendRequests = const [],
    this.isLoading = true,
    this.error,
  });

  UserState copyWith({
    UserApp? userApp,
    List<UserApp>? listFriends,
    List<UserApp>? listFriendRequests,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      userApp: userApp ?? this.userApp,
      listFriends: listFriends ?? this.listFriends,
      listFriendRequests: listFriendRequests ?? this.listFriendRequests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    userApp,
    listFriends,
    listFriendRequests,
    isLoading,
    error,
  ];
}
