import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintain_chat_app/models/message_models.dart';

abstract class MessageRepo {
  Future<void> init(String chatId, String participantId);
  Future<void> dispose();
  Future<void> clearAllMessages();
  Stream<List<MessageItem>> loadMessages(String chatId);
  Future<void> createMessage(MessageItem message, String chatId);
  Future<void> undoMessage(String chatId, Timestamp sendAt);
  Future<void> replyMessage(String messageId, String replyContent);
  Future<void> loadMoreMessages(String chatId, Timestamp lastTimestamp);
}
