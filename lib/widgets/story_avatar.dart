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
      arguments: {'user': widget.user, 'chatId': chatId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final avatarSize = ResponsiveHelper.getAvatarSize(context);
    final horizontalPadding = ResponsiveHelper.getResponsiveSize(
      context,
      8,
    ).clamp(6.0, 12.0);
    final fontSize = ResponsiveHelper.getFontSize(context, 12);
    final onlineIndicatorSize = ResponsiveHelper.getResponsiveSize(
      context,
      14,
    ).clamp(12.0, 16.0);

    final isOnline = widget.user.isOnline ?? false;

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
            width: avatarSize + 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                              isOnline
                                  ? colorScheme.primary
                                  : theme.disabledColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(
                        child:
                            widget.user.avatarUrl?.isNotEmpty ?? false
                                ? Image.network(
                                  widget.user.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildPlaceholder(theme),
                                )
                                : _buildPlaceholder(theme),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: onlineIndicatorSize,
                          height: onlineIndicatorSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.user.userName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: fontSize,
                    fontWeight: isOnline ? FontWeight.w600 : FontWeight.normal,
                    color: colorScheme.onSurface.withOpacity(
                      isOnline ? 1.0 : 0.7,
                    ),
                  ),
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

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.disabledColor.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: ResponsiveHelper.getAvatarSize(context) * 0.5,
        color: theme.disabledColor,
      ),
    );
  }
}
