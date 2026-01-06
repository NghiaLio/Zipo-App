// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatBloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatEvent.dart';
import 'package:maintain_chat_app/bloc/chat/chatState.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import '../../utils/chatUtils.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/story_avatar.dart';
import '../../widgets/chat_tile.dart';
import '../../widgets/loading_placeholder.dart';
import '../../widgets/error_placeholder.dart';
import '../../widgets/empty_placeholder.dart';
import '../../widgets/search_widget.dart';
import '../../widgets/TopSnackBar.dart';

class MessengerHomePage extends StatefulWidget {
  const MessengerHomePage({super.key});

  @override
  State<MessengerHomePage> createState() => _MessengerHomePageState();
}

class _MessengerHomePageState extends State<MessengerHomePage> {
  bool _isSearching = false;
  @override
  void initState() {
    context.read<ChatBloc>().add(LoadChatsEvent());
    context.read<UserBloc>().add(LoadFriendUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Tin nhắn',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.getFontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<UserBloc, UserState>(
            buildWhen:
                (previous, current) =>
                    previous.listFriends != current.listFriends,
            builder: (context, userState) {
              final friends = userState.listFriends;
              return Padding(
                padding: screenPadding,
                child: SearchWidget(
                  allUsers: friends,
                  onUserSelected: (user) async {
                    // Lấy currentUserId từ FirebaseAuth thay vì UserBloc
                    final currentUserId =
                        FirebaseAuth.instance.currentUser?.uid ?? '';
                    if (currentUserId.isEmpty) {
                      log('Không tìm thấy user hiện tại');
                      return;
                    }

                    final chatId = ChatUtils.generateChatId(
                      user.id,
                      currentUserId,
                    );

                    log('Checking chat: $chatId');

                    final isExistingChat = await context
                        .read<ChatBloc>()
                        .chatRepository
                        .checkExistingChat(chatId);

                    log('Chat exists: $isExistingChat');

                    if (!isExistingChat) {
                      // Tạo chat mới
                      log('Creating new chat with: ${user.userName}');
                      context.read<ChatBloc>().add(
                        CreateChatEvent([user.id, currentUserId]),
                      );
                      // Đợi một chút để chat được tạo
                      await Future.delayed(const Duration(milliseconds: 300));
                    }

                    // Navigate đến chat detail
                    log('Navigating to chat detail for: ${user.userName}');
                    Navigator.pushNamed(
                      context,
                      '/chatDetail',
                      arguments: {'user': user, 'chatId': chatId},
                    );
                  },
                  onSearchStateChanged: (isSearching) {
                    setState(() {
                      _isSearching = isSearching;
                    });
                  },
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
          if (!_isSearching) ...[
            BlocBuilder<UserBloc, UserState>(
              buildWhen:
                  (previous, current) =>
                      previous.listFriends != current.listFriends ||
                      previous.isLoading != current.isLoading ||
                      previous.error != current.error,
              builder: (context, state) {
                log(state.toString());
                if (state.isLoading) {
                  return const LoadingPlaceholder(
                    message: 'Đang tải danh sách bạn bè...',
                  );
                } else if (state.error != null) {
                  return ErrorPlaceholder(
                    message: 'Không thể tải danh sách bạn bè: ${state.error}',
                    onRetry:
                        () => context.read<UserBloc>().add(
                          LoadFriendUsersEvent(),
                        ),
                  );
                }
                final friends = state.listFriends;
                return SizedBox(
                  height:
                      ResponsiveHelper.getStoryAvatarSize(context) +
                      ResponsiveHelper.getFontSize(context, 12) +
                      24,
                  child:
                      friends.isEmpty
                          ? const EmptyPlaceholder(
                            message: 'Chưa có bạn bè nào',
                            icon: Icons.people_outline,
                          )
                          : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: screenPadding,
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              return StoryAvatar(user: friends[index]);
                            },
                          ),
                );
              },
            ),
            const Divider(height: 1),
            BlocListener<ChatBloc, ChatState>(
              listenWhen: (previous, current) {
                // Chỉ lắng nghe khi deleteState thay đổi
                return previous.deleteState != current.deleteState;
              },
              listener: (context, state) {
                // Show SnackBar khi có lỗi từ delete hoặc create
                if (state.deleteState == false) {
                  showSnackBar.show_error(state.error!, context);
                } else if (state.deleteState == true) {
                  showSnackBar.show_success('Xóa tin nhắn thành công', context);
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen:
                    (previous, current) =>
                        previous.chats != current.chats ||
                        previous.isLoading != current.isLoading ||
                        previous.error != current.error,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Expanded(
                      child: LoadingPlaceholder(
                        message: 'Đang tải tin nhắn...',
                      ),
                    );
                  } else if (state.error != null) {
                    return Expanded(
                      child: ErrorPlaceholder(
                        message: 'Không thể tải tin nhắn: ${state.error}',
                        onRetry:
                            () =>
                                context.read<ChatBloc>().add(LoadChatsEvent()),
                      ),
                    );
                  }
                  final chatList = state.chats;
                  return Expanded(
                    child:
                        chatList.isEmpty
                            ? const EmptyPlaceholder(
                              message: 'Chưa có tin nhắn nào',
                              icon: Icons.chat_bubble_outline,
                            )
                            : ListView.builder(
                              itemCount: chatList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return ChatTile(chat: chatList[index]);
                              },
                            ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
