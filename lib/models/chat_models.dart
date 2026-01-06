import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/models/userModels.dart';

class ChatItem {
  final String id;
  final UserApp? participant;
  final String message;
  final String senderID;
  final String time;
  final int unreadCount;

  ChatItem({
    required this.id,
    required this.participant,
    required this.message,
    required this.time,
    required this.senderID,
    this.unreadCount = 0,
  });

  ChatItem copyWith({
    String? id,
    UserApp? participant,
    String? message,
    String? time,
    int? unreadCount,
    String? senderID,
  }) {
    return ChatItem(
      id: id ?? this.id,
      participant: participant ?? this.participant,
      message: message ?? this.message,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      senderID: senderID ?? this.senderID,
    );
  }
}

class ChatResponse {
  final String iD;
  final List<MessageItem> chats;
  final List<String> participants;

  ChatResponse({
    required this.iD,
    required this.chats,
    required this.participants,
  });

  ChatResponse copyWith({
    String? iD,
    List<MessageItem>? chats,
    List<String>? participants,
  }) {
    return ChatResponse(
      iD: iD ?? this.iD,
      chats: chats ?? this.chats,
      participants: participants ?? this.participants,
    );
  }

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      iD: json['ID_Room'] as String,
      chats:
          (json['listMessage'] as List<dynamic>?)
              ?.map(
                (chat) => MessageItem.fromJson(chat as Map<String, dynamic>),
              )
              .toList() ??
          [],
      participants: List<String>.from(
        json['participants'] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID_Room': iD,
      'chats': chats.map((chat) => chat.toMap()).toList(),
      'participants': participants,
    };
  }
}
