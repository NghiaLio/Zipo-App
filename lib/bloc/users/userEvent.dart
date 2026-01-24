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

class LoadFriendRequestsEvent extends UserEvent {}

class UpdateFriendRequestsEvent extends UserEvent {
  final List<UserApp> requests;

  UpdateFriendRequestsEvent(this.requests);

  @override
  List<Object?> get props => [requests];
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

class ToggleFriendRequestEvent extends UserEvent {
  final String friendId;
  final bool isSendRequest;

  ToggleFriendRequestEvent(
    this.friendId,
    this.isSendRequest, {
    required String currentUserId,
  });

  @override
  List<Object?> get props => [friendId, isSendRequest];
}

class RejectFriendRequestEvent extends UserEvent {
  final String senderId; // người gửi lời mời
  final String receiverId; // người nhận lời mời (currentUser)

  RejectFriendRequestEvent({required this.senderId, required this.receiverId});

  @override
  List<Object?> get props => [senderId, receiverId];
}

class ToggleFriendEvent extends UserEvent {
  final String friendId;
  final bool isFriend;

  ToggleFriendEvent(this.friendId, this.isFriend);

  @override
  List<Object?> get props => [friendId, isFriend];
}
