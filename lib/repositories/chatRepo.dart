import 'dart:async';
import 'package:maintain_chat_app/models/chat_models.dart';

abstract class ChatRepo {
  Future<void> init();
  Future<void> dispose();
  Future<void> clearCache();
  Stream<List<ChatItem>> loadChats();
  Future<void> deleteChat(String chatId);
  Future<void> updateChat(String chatId, String newMessage);
  Future<bool> checkExistingChat(String chatId);
  Future<String> createChat(List<String> participants);
}
