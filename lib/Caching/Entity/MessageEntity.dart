import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
import 'package:isar/isar.dart';
import 'package:maintain_chat_app/models/message_models.dart';

part 'MessageEntity.g.dart';

@Collection()
class MessageEntity {
  Id id = Isar.autoIncrement;
  @Index()
  late String chatId;
  late ReplyingToEmbedded? replyingTo;
  late String senderId;
  late String content;
  @Index()
  late String sendAt;
  late bool isRead;
  late bool isLatest;
  @enumerated
  late MessageTypeEntity messageType;

  MessageEntity({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sendAt,
    required this.isRead,
    required this.isLatest,
    required this.messageType,
    this.replyingTo,
  });
}

@Embedded()
class ReplyingToEmbedded {
  late String authorMessage;
  late String content;

  ReplyingToEmbedded({this.authorMessage = '', this.content = ''});
}

enum MessageTypeEntity { Text, Image, Video, Audio }

MessageEntity toMessageEntity(String chatId, MessageItem item) {
  final entity = MessageEntity(
    chatId: chatId,
    senderId: item.senderID,
    content: item.content,
    sendAt: item.sendAt.toDate().toIso8601String(),
    isRead: item.isSeen,
    isLatest: item.isLatest,
    messageType: MessageTypeEntity.values.byName(item.type.name),
    replyingTo:
        item.replyingTo != null
            ? ReplyingToEmbedded(
              authorMessage: item.replyingTo!['authorMessage'] ?? '',
              content: item.replyingTo!['content'] ?? '',
            )
            : null,
  );
  return entity;
}

MessageItem fromMessageEntity(MessageEntity messageEntity) {
  final MessageItem messageItem = MessageItem(
    senderID: messageEntity.senderId,
    content: messageEntity.content,
    sendAt: Timestamp.fromDate(DateTime.parse(messageEntity.sendAt)),
    isSeen: messageEntity.isRead,
    isLatest: messageEntity.isLatest,
    type: MessageType.values.byName(messageEntity.messageType.name),
    replyingTo:
        messageEntity.replyingTo != null
            ? {
              'authorMessage': messageEntity.replyingTo!.authorMessage,
              'content': messageEntity.replyingTo!.content,
            }
            : null,
  );
  return messageItem;
}
