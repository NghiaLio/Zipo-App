// ignore_for_file: file_names

import 'package:isar/isar.dart';
import '../../models/chat_models.dart';
import '../Entity/ChatEntity.dart';

class IsarChatDao {
  final Isar isar;

  IsarChatDao(this.isar);

  Stream<List<ChatItem>> watchChats() {
    final chatEntities = isar.chatEntitys
        .where()
        .sortByTimeDesc() // Sắp xếp theo thời gian giảm dần (mới nhất lên trên)
        .watch(fireImmediately: true)
        .asyncMap((entities) async {
          return entities.map((item) => fromChatEntity(item)).toList();
        });
    return chatEntities;
  }

  Future<void> upsert(ChatItem chat) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.chatEntitys.where().chatIdEqualTo(chat.id).findFirst();
      if (existing != null) {
        // Update existing
        existing.lastMessage = chat.message;
        existing.time = chat.time;
        existing.unreadCount = chat.unreadCount;
        existing.participant = UserEmbedded(
          userId: chat.participant?.id ?? '',
          name: chat.participant?.userName ?? '',
          email: chat.participant?.email ?? '',
          avatarUrl: chat.participant?.avatarUrl ?? '',
          isOnline: chat.participant?.isOnline ?? false,
        );
        await isar.chatEntitys.put(existing);
      } else {
        // Insert new
        final entity = toChatEntity(chat);
        await isar.chatEntitys.put(entity);
      }
    });
  }

  Future<void> clearAllChats() async {
    await isar.writeTxn(() async {
      await isar.chatEntitys.clear();
    });
  }

  Future<ChatItem?> getChatById(String chatId) async {
    final entity =
        await isar.chatEntitys.where().chatIdEqualTo(chatId).findFirst();
    if (entity != null) {
      return fromChatEntity(entity);
    }
    return null;
  }

  Future<void> deleteChat(String chatId) async {
    await isar.writeTxn(() async {
      final entity =
          await isar.chatEntitys.where().chatIdEqualTo(chatId).findFirst();
      if (entity != null) {
        await isar.chatEntitys.delete(entity.id);
      }
    });
  }

  // Future<void> markDeleted(String id) async {
  //   await isar.writeTxn(() async {
  //     final chat = await isar.chatEntitys.get(id);
  //     if (chat != null) {
  //       chat.isDeleted = true;
  //       await isar.chatEntitys.put(chat);
  //     }
  //   });
  // }
}
