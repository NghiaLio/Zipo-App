// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/auth/authStates.dart';
import 'package:maintain_chat_app/repositories/chatRepo.dart';
import 'package:maintain_chat_app/repositories/messageRepo.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';

import '../../models/userModels.dart';
import '../../repositories/authRepo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Authrepo authRepo;
  final ChatRepo chatRepository; // Thêm ChatRepo vào AuthBloc
  final UserRepo userRepository;
  final MessageRepo messageRepository;
  AuthBloc(this.authRepo, this.chatRepository, this.userRepository, this.messageRepository)
    : super(const AuthState()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<LogoutEvent>(_logOut);
    on<ResetPasswordEvent>(_resetPassword);
    on<CheckAuthEvent>(_checkAuth);
  }
  UserApp? _user;
  List<UserApp>? _allUser;

  UserApp? get userData => _user;
  List<UserApp>? get allUser => _allUser;

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final UserApp? user = await authRepo.login(event.email, event.password);
      if (user != null) {
        _user = user;
        emit(
          state.copyWith(user: user, isLoading: false, isAuthenticated: true),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            message: 'Tài khoản hoặc mật khẩu không đúng',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          message: 'Có lỗi',
        ),
      );
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final UserApp? user = await authRepo.register(
        event.name,
        event.email,
        event.password,
      );
      if (user != null) {
        _user = user;
        emit(
          state.copyWith(user: user, isLoading: false, isAuthenticated: false),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            message: 'Tạo tài khoản thất bại, thử lại sau',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          message: 'Tạo tài khoản thất bại, thử lại sau',
        ),
      );
    }
  }

  Future<void> _checkAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final UserApp? user = await authRepo.checkAuth();
      if (user != null) {
        _user = user;
        emit(
          state.copyWith(user: user, isAuthenticated: true, isLoading: false),
        );
      } else {
        emit(
          state.copyWith(isAuthenticated: false, user: null, isLoading: false),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          message: 'Có lỗi khi kiểm tra xác thực',
        ),
      );
    }
  }

  Future<void> _logOut(LogoutEvent event, Emitter<AuthState> emit) async {
    // Thêm: Dispose chat service để dừng sync cũ
    await chatRepository.dispose();
    await chatRepository.clearCache();
    await userRepository.dispose();
    await userRepository.clearCache();
    await messageRepository.dispose();
    await messageRepository.clearAllMessages();

    await authRepo.logOut();
    _user = null;
    emit(state.copyWith(isAuthenticated: false, user: null));
  }

  Future<void> _resetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final String? mess = await authRepo.resetPassword(event.email);
      if (mess != null) {
        emit(state.copyWith(isLoading: false, message: mess));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            message: 'Đặt lại mật khẩu thất bại, thử lại sau',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: 'Đặt lại mật khẩu thất bại, thử lại sau',
        ),
      );
    }
  }
}
