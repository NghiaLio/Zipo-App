import 'package:isar/isar.dart';
import 'package:maintain_chat_app/Caching/Entity/MessageEntity.dart';
import 'package:maintain_chat_app/models/message_models.dart';

class IsarMessageDao {
  final Isar isar;

  IsarMessageDao(this.isar);

  Stream<List<MessageItem>> watchMessages(String chatId) {
    final messageEntities = isar.messageEntitys
        .where()
        .chatIdEqualTo(chatId)
        .sortBySendAtDesc() // Sắp xếp theo thời gian gửi giảm dần (mới nhất trước)
        .watch(fireImmediately: true)
        .asyncMap((entities) async {
          return entities.map((item) => fromMessageEntity(item)).toList();
        });
    return messageEntities;
  }

  Future<void> upsert(MessageItem message, String chatId) async {
    await isar.writeTxn(() async {
      final sendAtString = message.sendAt.toDate().toIso8601String();

      // Check by senderId AND sendAt (chỉ bỏ qua khi trùng CẢ HAI)
      final existingBySenderAndTime =
          await isar.messageEntitys
              .where()
              .filter()
              .senderIdEqualTo(message.senderID)
              .and()
              .sendAtEqualTo(sendAtString)
              .findFirst();

      if (existingBySenderAndTime != null) {
        // Bỏ qua nếu đã tồn tại cùng sender và cùng thời gian (tránh duplicate)
        return;
      }

      // Insert new message
      final entity = toMessageEntity(chatId, message);
      await isar.messageEntitys.put(entity);
    });
  }

  Future<void> clearAllMessages() async {
    await isar.writeTxn(() async {
      await isar.messageEntitys.clear();
    });
  }

  Future<void> clearMessagesByChatId(String chatId) async {
    await isar.writeTxn(() async {
      await isar.messageEntitys.where().chatIdEqualTo(chatId).deleteAll();
    });
  }

  Future<void> syncMessages(List<MessageItem> messages, String chatId) async {
    await isar.writeTxn(() async {
      // Clear existing messages for this chat
      await isar.messageEntitys.where().chatIdEqualTo(chatId).deleteAll();

      // Add all new messages
      final entities = messages.map((m) => toMessageEntity(chatId, m)).toList();
      await isar.messageEntitys.putAll(entities);
    });
  }

  Future<void> upsertMessages(List<MessageItem> messages, String chatId) async {
    await isar.writeTxn(() async {
      for (var message in messages) {
        final sendAtString = message.sendAt.toDate().toIso8601String();
        final existingBySenderAndTime =
            await isar.messageEntitys
                .where()
                .filter()
                .senderIdEqualTo(message.senderID)
                .and()
                .sendAtEqualTo(sendAtString)
                .findFirst();

        if (existingBySenderAndTime == null) {
          final entity = toMessageEntity(chatId, message);
          await isar.messageEntitys.put(entity);
        }
      }
    });
  }

  Future<void> deleteMessageBySendAt(String sendAt) async {
    await isar.writeTxn(() async {
      final entity =
          await isar.messageEntitys.where().sendAtEqualTo(sendAt).findFirst();
      if (entity != null) {
        await isar.messageEntitys.delete(entity.id);
      }
    });
  }

  Future<void> deleteMessagesById(int id) async {
    await isar.writeTxn(() async {
      await isar.messageEntitys.delete(id);
    });
  }

  Future<MessageItem?> getMessageById(int id) async {
    final entity = await isar.messageEntitys.get(id);
    if (entity != null) {
      return fromMessageEntity(entity);
    }
    return null;
  }

  // get lastest message by chatId
  Future<MessageEntity?> getLatestMessage(String chatId) async {
    final entity =
        await isar.messageEntitys
            .where()
            .chatIdEqualTo(chatId)
            .sortBySendAtDesc()
            .findFirst();
    if (entity != null) {
      return entity;
    }
    return null;
  }

  // Update lastest message by chatId
  Future<void> updateLatestMessage(String chatId, bool isLatest) async {
    await isar.writeTxn(() async {
      final entity =
          await isar.messageEntitys
              .where()
              .chatIdEqualTo(chatId)
              .sortBySendAtDesc()
              .findFirst();
      if (entity != null) {
        entity.isLatest = isLatest;
        await isar.messageEntitys.put(entity);
      }
    });
  }

  // update seen status by chatId
  Future<void> updateSeenStatus(String chatId) async {
    await isar.writeTxn(() async {
      final entities =
          await isar.messageEntitys
              .where()
              .chatIdEqualTo(chatId)
              .filter()
              .isReadEqualTo(false)
              .findAll();
      for (var entity in entities) {
        entity.isRead = true;
        await isar.messageEntitys.put(entity);
      }
    });
  }

  // ✅ Update seen status chỉ cho messages của một sender cụ thể
  Future<void> updateSeenStatusBySender(String chatId, String senderId) async {
    await isar.writeTxn(() async {
      final entities =
          await isar.messageEntitys
              .where()
              .chatIdEqualTo(chatId)
              .filter()
              .senderIdEqualTo(senderId)
              .and()
              .isReadEqualTo(false)
              .findAll();
      for (var entity in entities) {
        entity.isRead = true;
        await isar.messageEntitys.put(entity);
      }
    });
  }
}
