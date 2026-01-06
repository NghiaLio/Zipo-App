// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatBloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatEvent.dart';
import 'package:maintain_chat_app/utils/chatUtils.dart';
import '../utils/responsive_helper.dart';
import '../models/userModels.dart';

class StoryAvatar extends StatefulWidget {
  final UserApp user;

  const StoryAvatar({super.key, required this.user});

  @override
  State<StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void tapToAvatar() async {
    final String chatId = ChatUtils.generateChatId(
      widget.user.id,
      _firebaseAuth.currentUser?.uid ?? '',
    );
    final bool isExistingChat = await context
        .read<ChatBloc>()
        .chatRepository
        .checkExistingChat(chatId);
    if (!isExistingChat) {
      // Create new chat
       context.read<ChatBloc>().add(
        CreateChatEvent([widget.user.id, _firebaseAuth.currentUser?.uid ?? '']),
      );
      
    }
    // Navigate to existing chat screen
      Navigator.pushNamed(
        context,
        '/chatDetail',
        arguments: {
          'user': widget.user,
          'chatId': chatId,
        },
      );
    
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = ResponsiveHelper.getAvatarSize(context);
    final horizontalPadding = ResponsiveHelper.getResponsiveSize(
      context,
      8,
    ).clamp(6.0, 12.0);
    final fontSize = ResponsiveHelper.getFontSize(context, 12);
    final addIconSize = ResponsiveHelper.getResponsiveSize(
      context,
      20,
    ).clamp(16.0, 24.0);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: tapToAvatar,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            width: avatarSize + 12,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              widget.user.isOnline ?? false
                                  ? Colors.green
                                  : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child:
                          widget.user.avatarUrl?.isNotEmpty ?? false
                              ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  image:
                                      widget.user.avatarUrl?.isNotEmpty ?? false
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              widget.user.avatarUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                              )
                              : CircleAvatar(
                                radius: avatarSize / 2,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: avatarSize * 0.6,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                    if (widget.user.isOnline ?? false)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: addIconSize,
                          height: addIconSize,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.circle,
                            size: addIconSize * 0.4,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSize(context, 4),
                ),
                Text(
                  widget.user.userName,
                  style: TextStyle(fontSize: fontSize),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
