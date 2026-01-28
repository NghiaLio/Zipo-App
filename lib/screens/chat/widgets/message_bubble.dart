import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
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
    BuildContext context,
    bool isMe,
    bool isRead,
    DateTime timestamp, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor =
        color ??
        (isMe ? const Color.fromARGB(179, 248, 248, 248) : theme.disabledColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm').format(timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: textColor,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          Icon(
            isRead ? Icons.done_all : Icons.check,
            size: 14,
            color:
                isRead
                    ? (color == null ? Colors.white : colorScheme.primary)
                    : textColor,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                        ? colorScheme.primary
                        : theme.disabledColor.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  if (message.type == MessageType.Text)
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
                border:
                    !isMe
                        ? Border.all(
                          color: theme.dividerColor.withOpacity(0.05),
                        )
                        : null,
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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.disabledColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onReply(message),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.reply_rounded,
              size: 18,
              color: theme.disabledColor,
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMe = message.senderID == currentUserId;
    if (!isMe) return; // Chỉ hiện options (xóa) cho tin nhắn của chính mình

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
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
                      color: theme.disabledColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline_rounded,
                      color: colorScheme.error,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.delete_message_action,
                      style: TextStyle(color: colorScheme.error),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                _buildReplyPreview(context, message.replyingTo!, isMe),
              Text(
                message.content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isMe ? Colors.white : colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusRow(context, isMe, message.isSeen, timestamp),
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
                child: _buildReplyPreview(context, message.replyingTo!, false),
              ),
            ImageMessageWidget(
              imageUrl: imageUrl,
              onTap: () {
                final currentUser = context.read<UserBloc>().state.userApp;
                final authorName =
                    isMe
                        ? (currentUser?.userName ??
                            AppLocalizations.of(context)!.me_label_chat)
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
                context,
                isMe,
                message.isSeen,
                timestamp,
                color: theme.disabledColor,
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
                child: _buildReplyPreview(context, message.replyingTo!, false),
              ),
            VideoMessageWidget(
              videoUrl: videoUrl,
              onTap: () {
                final currentUser = context.read<UserBloc>().state.userApp;
                final authorName =
                    isMe
                        ? (currentUser?.userName ??
                            AppLocalizations.of(context)!.me_label_chat)
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
                context,
                isMe,
                message.isSeen,
                timestamp,
                color: theme.disabledColor,
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
                child: _buildReplyPreview(context, message.replyingTo!, false),
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
                context,
                isMe,
                message.isSeen,
                timestamp,
                color: theme.disabledColor,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildReplyPreview(
    BuildContext context,
    Map<String, String> replyingTo,
    bool isMe,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            isMe
                ? Colors.white.withOpacity(0.15)
                : colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMe ? Colors.white70 : colorScheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyingTo['authorMessage'] ?? '',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isMe ? Colors.white : colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            replyingTo['content'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color:
                  isMe
                      ? Colors.white70
                      : colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String chatId, message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.delete_message_confirm_title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.delete_message_confirm_message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        AppLocalizations.of(context)!.cancel_action,
                        style: TextStyle(color: theme.disabledColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<MessageBloc>().add(
                          UndoMessageEvent(chatId, message),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.delete_button),
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
