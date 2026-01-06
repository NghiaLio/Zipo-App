import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/bloc/chat/chatBloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatEvent.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';
import '../models/chat_models.dart';
import '../utils/responsive_helper.dart';
import 'dart:developer' as dev;

class ChatTile extends StatefulWidget {
  final ChatItem chat;

  const ChatTile({super.key, required this.chat});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool _isPressed = false;

  Future<void> _navigateToChatDetail() async {
    if (widget.chat.participant != null) {
      Navigator.pushNamed(
        context,
        '/chatDetail',
        arguments: {'user': widget.chat.participant, 'chatId': widget.chat.id},
      );
    }
    context.read<MessageBloc>().add(LoadMessagesEvent(widget.chat.id));
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = ResponsiveHelper.getAvatarSize(context);
    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final verticalPadding = ResponsiveHelper.getResponsiveSize(
      context,
      12,
    ).clamp(10.0, 16.0);
    final nameFontSize = ResponsiveHelper.getFontSize(context, 16);
    final messageFontSize = ResponsiveHelper.getFontSize(context, 14);
    final timeFontSize = ResponsiveHelper.getFontSize(context, 12);
    final badgeSize = ResponsiveHelper.getResponsiveSize(
      context,
      20,
    ).clamp(18.0, 24.0);
    final onlineIndicatorSize = ResponsiveHelper.getResponsiveSize(
      context,
      16,
    ).clamp(14.0, 18.0);

    return Slidable(
      key: ValueKey(widget.chat.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              dev.log(
                'Tắt/bật thông báo cho chat: ${widget.chat.participant?.userName}',
              );
              // TODO: Implement toggle notification logic
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.notifications_off,
            label: 'Thông báo',
          ),
          SlidableAction(
            onPressed: (context) async {
              dev.log('Xóa chat với: ${widget.chat.participant?.userName}');
              // Gọi sự kiện xóa chat
              context.read<ChatBloc>().add(DeleteChatEvent(widget.chat.id));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap:
            widget.chat.participant != null
                ? () => _navigateToChatDetail()
                : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _isPressed ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenPadding.left,
              vertical: verticalPadding,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    widget.chat.participant?.avatarUrl == null ||
                            widget.chat.participant?.avatarUrl!.isEmpty == true
                        ? CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: avatarSize * 0.6,
                            color: Colors.white,
                          ),
                        )
                        : CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.chat.participant?.avatarUrl ?? '',
                          ),
                        ),
                    if (widget.chat.participant?.isOnline ?? false)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: onlineIndicatorSize,
                          height: onlineIndicatorSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  width: ResponsiveHelper.getResponsiveSize(context, 12),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chat.participant?.userName ?? 'Unknown User',
                        style: TextStyle(
                          fontSize: nameFontSize,
                          fontWeight:
                              widget.chat.senderID ==
                                          widget.chat.participant?.id &&
                                      widget.chat.unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSize(context, 2),
                      ),
                      Text(
                        widget.chat.message.isNotEmpty
                            ? widget.chat.message
                            : 'Hãy bắt đầu cuộc trò chuyện!',
                        style: TextStyle(
                          fontSize: messageFontSize,
                          color:
                              widget.chat.senderID ==
                                          widget.chat.participant?.id &&
                                      widget.chat.unreadCount > 0
                                  ? Colors.black87
                                  : Colors.grey[600],
                          fontWeight:
                              widget.chat.senderID ==
                                          widget.chat.participant?.id &&
                                      widget.chat.unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ConvertTime.formatTimestamp(
                        DateTime.parse(widget.chat.time),
                      ),
                      style: TextStyle(
                        fontSize: timeFontSize,
                        color:
                            widget.chat.unreadCount > 0 &&
                                    widget.chat.senderID ==
                                        widget.chat.participant?.id
                                ? const Color(0xFF0288D1)
                                : Colors.grey[600],
                        fontWeight:
                            widget.chat.unreadCount > 0 &&
                                    widget.chat.senderID ==
                                        widget.chat.participant?.id
                                ? FontWeight.w600
                                : FontWeight.normal,
                      ),
                    ),
                    if (widget.chat.unreadCount > 0 &&
                        widget.chat.senderID ==
                            widget.chat.participant?.id) ...[
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSize(context, 4),
                      ),
                      Container(
                        padding: EdgeInsets.all(badgeSize * 0.3),
                        constraints: BoxConstraints(
                          minWidth: badgeSize,
                          minHeight: badgeSize,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0288D1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            widget.chat.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: timeFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
