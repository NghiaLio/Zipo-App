import 'package:isar/isar.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import '../../models/chat_models.dart';
part 'ChatEntity.g.dart';

@Collection()
class ChatEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String chatId;
  late UserEmbedded participant;
  late String lastMessage;
  late String senderID;
  @Index()
  late String time;
  late int unreadCount;

  ChatEntity({
    required this.chatId,
    required this.lastMessage,
    required this.unreadCount,
    required this.time,
    required this.senderID,
  });
}

@Embedded()
class UserEmbedded {
  late String userId;
  late String name;
  late String email;
  late String avatarUrl;
  late bool isOnline;

  UserEmbedded({
    this.userId = '',
    this.name = '',
    this.email = '',
    this.avatarUrl = '',
    this.isOnline = false,
  });
}

ChatEntity toChatEntity(ChatItem item) {
  final entity = ChatEntity(
    chatId: item.id,
    lastMessage: item.message,
    time: item.time,
    unreadCount: item.unreadCount,
    senderID: item.senderID,
  );
  entity.participant = UserEmbedded(
    userId: item.participant?.id ?? '',
    name: item.participant?.userName ?? '',
    email: item.participant?.email ?? '',
    avatarUrl: item.participant?.avatarUrl ?? '',
    isOnline: item.participant?.isOnline ?? false,
  );
  return entity;
}

ChatItem fromChatEntity(ChatEntity chatEntity) {
  final participants = chatEntity.participant;
  final ChatItem chatItem = ChatItem(
    id: chatEntity.chatId,
    participant: UserApp(
      id: participants.userId,
      userName: participants.name,
      email: participants.email,
      avatarUrl: participants.avatarUrl,
      isOnline: participants.isOnline,
    ),
    message: chatEntity.lastMessage,
    time: chatEntity.time,
    unreadCount: chatEntity.unreadCount,
    senderID: chatEntity.senderID,
  );

  return chatItem;
}
