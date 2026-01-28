import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSendMessage;
  final VoidCallback? onAttachmentPressed;
  final Map<String, String>? replyingTo;
  final VoidCallback? onCancelReply;

  const MessageInput({
    super.key,
    required this.textController,
    required this.onSendMessage,
    this.onAttachmentPressed,
    this.replyingTo,
    this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(color: colorScheme.primary, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.replying_label(replyingTo!['authorMessage']!),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            replyingTo!['content'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: theme.disabledColor,
                      ),
                      onPressed: onCancelReply,
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  onPressed: onAttachmentPressed,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: textController,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.type_message_hint,
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onSendMessage,
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
