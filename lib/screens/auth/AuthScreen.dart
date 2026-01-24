// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/screens/auth/Login.dart';
import 'package:maintain_chat_app/screens/home/home_chat_screen.dart';
import 'package:maintain_chat_app/widgets/Loading.dart';

import '../../bloc/auth/authBloc.dart';
import '../../bloc/auth/authStates.dart';
import '../../bloc/chat/chatBloc.dart';
import '../../bloc/chat/chatEvent.dart';

class AuthScreen extends StatefulWidget {
  RemoteMessage? initialMessage;
  AuthScreen({super.key, this.initialMessage});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Loading(
                heightWidth: MediaQuery.of(context).size.width * 0.1,
                color: Color(0xFF0288D1),
              ),
            ),
          );
        } else if (state.isAuthenticated) {
          return const MainScreen();
        } else {
          return const Login();
        }
      },
      listener: (context, state) async {
        if (state.isAuthenticated) {
          // Lấy instance từ AuthBloc thay vì tạo mới
          final authBloc = context.read<AuthBloc>();
          await authBloc.chatRepository.init();
          await authBloc.userRepository.init();
          await authBloc.postRepository.initPosts(state.user!);

          final userId = state.user?.id;
          if (userId != null) {
            context.read<UserBloc>().add(LoadUsersEvent(userId));
          }

          context.read<ChatBloc>().add(LoadChatsEvent());
          context.read<UserBloc>().add(LoadFriendUsersEvent());
        }
      },
    );
  }
}
