import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image, Video, Audio }

class MessageItem {
  String senderID;
  String content;
  Map<String, String>?
  replyingTo; //ex : replyingTo: {'authorMessage': 'content'}
  MessageType type;
  bool isSeen;
  bool isLatest;
  Timestamp sendAt;

  MessageItem({
    required this.senderID,
    required this.content,
    this.replyingTo,
    required this.type,
    required this.sendAt,
    required this.isSeen,
    required this.isLatest,
  });

  MessageItem copyWith({
    String? senderID,
    String? content,
    Map<String, String>? replyingTo,
    MessageType? type,
    Timestamp? sendAt,
    bool? isSeen,
    bool? isLatest,
  }) {
    return MessageItem(
      senderID: senderID ?? this.senderID,
      content: content ?? this.content,
      replyingTo: replyingTo ?? this.replyingTo,
      type: type ?? this.type,
      sendAt: sendAt ?? this.sendAt,
      isSeen: isSeen ?? this.isSeen,
      isLatest: isLatest ?? this.isLatest,
    );
  }

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      senderID: json['senderID'] as String,
      content: json['content'] as String,
      replyingTo:
          json['replyingTo'] != null
              ? Map<String, String>.from(json['replyingTo'] as Map)
              : null,
      type: MessageType.values.byName(json['type'] as String),
      sendAt: json['sendAt'] as Timestamp,
      isSeen: json['seen'] as bool? ?? false,
      isLatest: json['isLatest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'content': content,
      'replyingTo': replyingTo,
      'type': type.name,
      'seen': isSeen,
      'isLatest': isLatest,
      'sendAt': sendAt,
    };
  }
}
