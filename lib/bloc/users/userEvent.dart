// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/userModels.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserEvent {
  final String userId;

  LoadUsersEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UsersUpdatedEvent extends UserEvent {
  final List<UserApp> users;

  UsersUpdatedEvent(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersErrorEvent extends UserEvent {
  final String error;

  UsersErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class LoadFriendUsersEvent extends UserEvent {}

class UpdateListFriendUsersEvent extends UserEvent {
  final List<UserApp> users;

  UpdateListFriendUsersEvent(this.users);

  @override
  List<Object?> get props => [users];
}

class UpdateUserProfileEvent extends UserEvent {
  final UserApp user;

  UpdateUserProfileEvent(this.user);

  @override
  List<Object?> get props => [user];
}
