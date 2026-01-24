// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';

import '../../models/userModels.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepository;
  StreamSubscription<List<UserApp>>? _usersSubscription;

  UserBloc({required this.userRepository}) : super(UserState()) {
    on<LoadUsersEvent>(_onLoadUsers);
    // on<UsersUpdatedEvent>(_onUsersUpdated);
    on<UsersErrorEvent>(_onUsersError);
    on<LoadFriendUsersEvent>(_onLoadFriendUsers);
    on<UpdateListFriendUsersEvent>(_onUpdateListFriendUsers);
    on<LoadFriendRequestsEvent>(_onLoadFriendRequests);
    on<UpdateFriendRequestsEvent>(_onUpdateFriendRequests);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<ToggleFriendRequestEvent>(_onToggleFriendRequest);
    on<RejectFriendRequestEvent>(_onRejectFriendRequest);
    on<ToggleFriendEvent>(_onToggleFriend);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await userRepository.getUserById(event.userId);
      emit(state.copyWith(userApp: user, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLoadFriendUsers(
    LoadFriendUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState(isLoading: true));

    try {
      // Cancel previous subscription if exists
      await _usersSubscription?.cancel();

      // Listen to the stream from repository
      _usersSubscription = userRepository.loadAllFriends().listen(
        (users) {
          add(UpdateListFriendUsersEvent(users));
        },
        onError: (error) {
          add(UsersErrorEvent(error.toString()));
        },
      );
    } catch (e) {
      emit(UserState(error: e.toString(), isLoading: false));
    }
  }

  void _onUpdateListFriendUsers(
    UpdateListFriendUsersEvent event,
    Emitter<UserState> emit,
  ) {
    emit(
      state.copyWith(listFriends: event.users, isLoading: false, error: null),
    );
  }

  void _onUsersError(UsersErrorEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(error: event.error, isLoading: false));
  }

  Future<void> _onLoadFriendRequests(
    LoadFriendRequestsEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final requests = await userRepository.loadFriendRequest();
      emit(
        state.copyWith(
          listFriendRequests: requests,
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onUpdateFriendRequests(
    UpdateFriendRequestsEvent event,
    Emitter<UserState> emit,
  ) {
    emit(
      state.copyWith(
        listFriendRequests: event.requests,
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await userRepository.updateUserProfile(event.user);

      // Reload user data sau khi update
      final updatedUser = await userRepository.getUserById(event.user.id);
      emit(state.copyWith(userApp: updatedUser, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onToggleFriendRequest(
    ToggleFriendRequestEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await userRepository.toggleFriendRequest(
        event.friendId,
        event.isSendRequest,
      );
      add(LoadUsersEvent(state.userApp?.id ?? ''));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleFriend(
    ToggleFriendEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await userRepository.toggleFriend(event.friendId, event.isFriend);
      add(LoadUsersEvent(state.userApp?.id ?? ''));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRejectFriendRequest(
    RejectFriendRequestEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await userRepository.rejectFriendRequest(
        senderId: event.senderId,
        receiverId: event.receiverId,
      );
      add(LoadUsersEvent(state.userApp?.id ?? ''));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
