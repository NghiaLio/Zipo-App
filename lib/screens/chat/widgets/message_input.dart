import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSendMessage;
  final VoidCallback? onAttachmentPressed;

  const MessageInput({
    super.key,
    required this.textController,
    required this.onSendMessage,
    this.onAttachmentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.blueAccent,
                size: 28,
              ),
              onPressed: onAttachmentPressed,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: "Nhập tin nhắn...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSendMessage,
              child: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
