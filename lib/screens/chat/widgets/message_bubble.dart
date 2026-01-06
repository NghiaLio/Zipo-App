import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'image_message_widget.dart';
import 'video_message_widget.dart';
import 'audio_message_widget.dart';

class MessageBubble extends StatelessWidget {
  final MessageItem message;
  final String currentUserId;
  final String chatId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.chatId,
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
          if (isMe) ...[
            _buildActionButtons(context, isMe),
            const SizedBox(width: 4),
          ],
          Container(
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
          if (!isMe) ...[
            const SizedBox(width: 4),
            _buildActionButtons(context, isMe),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isMe) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Implement reply functionality
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.reply_rounded,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
          if (isMe)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    () => _showDeleteConfirmation(
                      context,
                      chatId,
                      message.sendAt,
                    ),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.red[400],
                  ),
                ),
              ),
            ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ImageMessageWidget(
              imageUrl: message.content
                  .trim()
                  .replaceAll('\n', '')
                  .replaceAll('\r', ''),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VideoMessageWidget(
              videoUrl: message.content
                  .trim()
                  .replaceAll('\n', '')
                  .replaceAll('\r', ''),
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
