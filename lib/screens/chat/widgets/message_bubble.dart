import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import '../../../widgets/media_viewer_page.dart';
import 'image_message_widget.dart';
import 'video_message_widget.dart';
import 'audio_message_widget.dart';

class MessageBubble extends StatelessWidget {
  final MessageItem message;
  final String currentUserId;
  final String chatId;
  final UserApp recipientUser;
  final Function(MessageItem) onReply;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.chatId,
    required this.recipientUser,
    required this.onReply,
  });

  Widget _buildStatusRow(
    bool isMe,
    bool isRead,
    DateTime timestamp, {
    Color? color,
  }) {
    final textColor = color ?? (isMe ? Colors.white70 : Colors.grey);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm').format(timestamp),
          style: TextStyle(fontSize: 10, color: textColor),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          Icon(
            isRead ? Icons.done_all : Icons.check,
            size: 14,
            color:
                isRead
                    ? (color == null ? Colors.white : Colors.blueAccent)
                    : textColor,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderID == currentUserId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMe) ...[_buildReplyButton(context), const SizedBox(width: 4)],
          GestureDetector(
            onLongPress: () => _showOptionsBottomSheet(context),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color:
                    isMe && message.type == MessageType.Text
                        ? Colors.blueAccent
                        : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  if (message.type == MessageType.Text)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildContent(context),
              ),
            ),
          ),
          if (!isMe) ...[const SizedBox(width: 4), _buildReplyButton(context)],
        ],
      ),
    );
  }

  Widget _buildReplyButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onReply(message),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.reply_rounded, size: 18, color: Colors.grey[700]),
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final isMe = message.senderID == currentUserId;
    if (!isMe) return; // Chỉ hiện options (xóa) cho tin nhắn của chính mình

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Xóa tin nhắn',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context, chatId, message.sendAt);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isMe = message.senderID == currentUserId;
    final timestamp = message.sendAt.toDate();

    switch (message.type) {
      case MessageType.Text:
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyingTo != null)
                _buildReplyPreview(message.replyingTo!, isMe),
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusRow(isMe, message.isSeen, timestamp),
            ],
          ),
        );

      case MessageType.Image:
        final imageUrl = message.content
            .trim()
            .replaceAll('\n', '')
            .replaceAll('\r', '');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.replyingTo != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildReplyPreview(message.replyingTo!, false),
              ),
            ImageMessageWidget(
              imageUrl: imageUrl,
              onTap: () {
                final currentUser = context.read<UserBloc>().state.userApp;
                final authorName =
                    isMe
                        ? (currentUser?.userName ?? 'Tôi')
                        : recipientUser.userName;
                final authorAvatar =
                    isMe
                        ? (currentUser?.avatarUrl ?? '')
                        : (recipientUser.avatarUrl ?? '');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MediaViewerPage(
                          url: imageUrl,
                          mediaType: 'image',
                          userName: authorName,
                          userAvatar: authorAvatar,
                        ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
              child: _buildStatusRow(
                isMe,
                message.isSeen,
                timestamp,
                color: Colors.grey,
              ),
            ),
          ],
        );

      case MessageType.Video:
        final videoUrl = message.content
            .trim()
            .replaceAll('\n', '')
            .replaceAll('\r', '');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.replyingTo != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildReplyPreview(message.replyingTo!, false),
              ),
            VideoMessageWidget(
              videoUrl: videoUrl,
              onTap: () {
                final currentUser = context.read<UserBloc>().state.userApp;
                final authorName =
                    isMe
                        ? (currentUser?.userName ?? 'Tôi')
                        : recipientUser.userName;
                final authorAvatar =
                    isMe
                        ? (currentUser?.avatarUrl ?? '')
                        : (recipientUser.avatarUrl ?? '');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MediaViewerPage(
                          url: videoUrl,
                          mediaType: 'video',
                          userName: authorName,
                          userAvatar: authorAvatar,
                        ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
              child: _buildStatusRow(
                isMe,
                message.isSeen,
                timestamp,
                color: Colors.grey,
              ),
            ),
          ],
        );

      case MessageType.Audio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.replyingTo != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: _buildReplyPreview(message.replyingTo!, false),
              ),
            AudioMessageWidget(
              audioUrl: message.content
                  .trim()
                  .replaceAll('\n', '')
                  .replaceAll('\r', ''),
              isMe: isMe,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 4),
              child: _buildStatusRow(
                isMe,
                message.isSeen,
                timestamp,
                color: Colors.grey,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildReplyPreview(Map<String, String> replyingTo, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe ? Colors.white.withOpacity(0.2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMe ? Colors.white70 : Colors.blueAccent,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyingTo['authorMessage'] ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isMe ? Colors.white : Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            replyingTo['content'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: isMe ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String chatId, message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Xác nhận xóa tin nhắn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Bạn có chắc chắn muốn xóa tin nhắn này không?'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MessageBloc>().add(
                        UndoMessageEvent(chatId, message),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Xóa',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
