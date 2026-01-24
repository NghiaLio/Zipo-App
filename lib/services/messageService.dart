import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListMessages.dart';
import 'package:maintain_chat_app/Caching/Entity/MessageEntity.dart';
import 'package:maintain_chat_app/models/chat_models.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/repositories/messageRepo.dart';

class MessageService implements MessageRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final IsarMessageDao _isarMessageDao = IsarMessageDao(
    InitializedCaching.isar,
  );
  StreamSubscription? _remoteSub;
  @override
  Future<void> createMessage(MessageItem message, String chatId) async {
    try {
      // Optimistic update: upsert local trước
      await _isarMessageDao.updateLatestMessage(chatId, false);
      await _isarMessageDao.upsert(message, chatId);

      //remote - Tối ưu: thêm message và cập nhật isLatest trong 1 lần
      // Bước 1: Fetch toàn bộ messages và set isLatest = false
      final List<MessageItem> listMess = await _firebaseFirestore
          .collection('Chats')
          .doc(chatId)
          .get()
          .then((snapshot) {
            if (!snapshot.exists || snapshot.data() == null) {
              return <MessageItem>[];
            }
            return ChatResponse.fromJson(snapshot.data()!).chats;
          });

      // Set tất cả message cũ về isLatest = false
      final List<MessageItem> updatedOldMessages =
          listMess.map((mess) {
            return MessageItem(
              senderID: mess.senderID,
              content: mess.content,
              replyingTo: mess.replyingTo,
              type: mess.type,
              sendAt: mess.sendAt,
              isLatest: false,
              isSeen: mess.isSeen,
            );
          }).toList();

      // Thêm message mới với isLatest = true
      final MessageItem newMessageWithLatest = MessageItem(
        senderID: message.senderID,
        content: message.content,
        replyingTo: message.replyingTo,
        type: message.type,
        sendAt: message.sendAt,
        isLatest: true,
        isSeen: message.isSeen,
      );

      updatedOldMessages.add(newMessageWithLatest);

      // Bước 2: Update toàn bộ array 1 lần duy nhất
      await _firebaseFirestore.collection('Chats').doc(chatId).update({
        'listMessage': updatedOldMessages.map((mess) => mess.toMap()).toList(),
      });

      // if (mess.type == MessageType.Image) {
      //   sendPushNotification(currentUser, receiveUser, 'Sent a Image');
      // } else if (mess.type == MessageType.Audio) {
      //   sendPushNotification(currentUser, receiveUser, 'Sent a Audio');
      // } else if (mess.type == MessageType.Video) {
      //   sendPushNotification(currentUser, receiveUser, 'Sent a Video');
      // } else {
      //   sendPushNotification(currentUser, receiveUser, mess.content);
      // }
    } catch (e) {
      // Nếu fail, delete khỏi local by sendAt
      final sendAtString = message.sendAt.toDate().toIso8601String();
      await _isarMessageDao.deleteMessageBySendAt(sendAtString);
      throw Exception('Failed to create message: $e');
    }
  }

  @override
  Stream<List<MessageItem>> loadMessages(String chatId) {
    return _isarMessageDao.watchMessages(chatId);
  }

  @override
  Future<void> replyMessage(String messageId, String replyContent) {
    // TODO: implement replyMessage
    throw UnimplementedError();
  }

  @override
  Future<void> undoMessage(String chatId, Timestamp sendAt) async {
    try {
      // Xóa từ Firestore
      final List<MessageItem> listMess = await _firebaseFirestore
          .collection('Chats')
          .doc(chatId)
          .get()
          .then((snapshot) {
            return ChatResponse.fromJson(snapshot.data()!).chats;
          });

      //delete mess
      final List<MessageItem> listNew =
          listMess.where((mess) => mess.sendAt != sendAt).toList();

      // ✅ SẮP XẾP theo timestamp để lấy message mới nhất thực sự
      if (listNew.isNotEmpty) {
        listNew.sort((a, b) => a.sendAt.compareTo(b.sendAt));
      }

      // Set tất cả về isLatest = false
      final List<MessageItem> updatedMessages =
          listNew.map((mess) {
            return MessageItem(
              senderID: mess.senderID,
              content: mess.content,
              replyingTo: mess.replyingTo,
              type: mess.type,
              sendAt: mess.sendAt,
              isLatest: false,
              isSeen: mess.isSeen,
            );
          }).toList();

      // Set message cuối cùng (mới nhất theo thời gian) là isLatest = true
      if (updatedMessages.isNotEmpty) {
        final lastMessage = updatedMessages.last;
        updatedMessages[updatedMessages.length - 1] = MessageItem(
          senderID: lastMessage.senderID,
          content: lastMessage.content,
          replyingTo: lastMessage.replyingTo,
          type: lastMessage.type,
          sendAt: lastMessage.sendAt,
          isLatest: true,
          isSeen: lastMessage.isSeen,
        );
      }

      //save to cloud_firestore
      await _firebaseFirestore.collection('Chats').doc(chatId).update({
        'listMessage': updatedMessages.map((mess) => mess.toMap()).toList(),
      });
      // Xóa từ Isar
      await _isarMessageDao.deleteMessageBySendAt(
        sendAt.toDate().toIso8601String(),
      );
      await _isarMessageDao.updateLatestMessage(chatId, true);
    } catch (e) {
      throw Exception('Failed to undo message: $e');
    }
  }

  @override
  Future<void> clearAllMessages() async {
    await _isarMessageDao.clearAllMessages();
  }

  @override
  Future<void> dispose() async {
    await _remoteSub?.cancel();
    _remoteSub = null;
  }

  @override
  Future<void> init(String chatId, String participantId) async {
    await dispose();
    // Khởi động đồng bộ tin nhắn từ xa nếu cần
    _startRemoteSync(chatId);

    // Cập nhật trạng thái đã xem khi khởi tạo
    // participantId = người gửi message cho mình, mình đang đọc → set isSeen = true
    await _updateSeenStatus(chatId, participantId);
  }

  void _startRemoteSync(String chatId) {
    _remoteSub ??= _firebaseFirestore
        .collection('Chats')
        .where('ID_Room', isEqualTo: chatId)
        // .orderBy('sendAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
          for (final change in snapshot.docChanges) {
            final data = change.doc.data();
            if (data == null) continue;
            final chatResponse = ChatResponse.fromJson(data);
            final List<MessageItem> messages = chatResponse.chats;

            // Sắp xếp theo sendAt tăng dần (message cũ nhất trước)
            messages.sort((a, b) => a.sendAt.compareTo(b.sendAt));

            // Lấy 20 messages cuối cùng (mới nhất)
            int startIndex = (messages.length - 20).clamp(0, messages.length);
            List<MessageItem> last20 = messages.sublist(startIndex);

            // Clear chỉ 1 lần trước khi insert tất cả messages
            await _isarMessageDao.clearAllMessages();

            for (final message in last20) {
              await _isarMessageDao.upsert(message, chatId);
            }
          }
        });
  }

  Future<void> _updateSeenStatus(String chatId, String participantId) async {
    try {
      final List<MessageItem> listMess = await _firebaseFirestore
          .collection('Chats')
          .doc(chatId)
          .get()
          .then((snapshot) {
            if (!snapshot.exists || snapshot.data() == null) {
              return <MessageItem>[];
            }
            return ChatResponse.fromJson(snapshot.data()!).chats;
          });

      // ✅ Chỉ cập nhật messages của participant (người kia) mà chưa seen
      bool hasUnseen = listMess.any(
        (mess) => mess.senderID == participantId && !mess.isSeen,
      );

      if (!hasUnseen) {
        // Không có message chưa seen → không cần update
        return;
      }

      final List<MessageItem> updatedMessages =
          listMess.map((mess) {
            // ✅ Chỉ set isSeen = true cho message của participant (người gửi cho mình)
            // Message của mình gửi thì giữ nguyên isSeen
            if (mess.senderID == participantId && !mess.isSeen) {
              return MessageItem(
                senderID: mess.senderID,
                content: mess.content,
                replyingTo: mess.replyingTo,
                type: mess.type,
                sendAt: mess.sendAt,
                isLatest: mess.isLatest,
                isSeen: true, // ✅ Set seen cho message của participant
              );
            } else {
              // Giữ nguyên message khác
              return mess;
            }
          }).toList();

      await _firebaseFirestore.collection('Chats').doc(chatId).update({
        'listMessage': updatedMessages.map((mess) => mess.toMap()).toList(),
      });

      // Cập nhật trong Isar - chỉ update message của participant
      await _isarMessageDao.updateSeenStatusBySender(chatId, participantId);
    } catch (e) {
      throw Exception('Failed to update seen status: $e');
    }
  }
}
