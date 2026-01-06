import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/models/chat_models.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/repositories/chatRepo.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';
import 'package:maintain_chat_app/utils/chatUtils.dart';

import '../Caching/Database/ListChat.dart';
import '../models/message_models.dart';

class ChatService implements ChatRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepo _userRepo;
  final IsarChatDao _isarChatDao = IsarChatDao(InitializedCaching.isar);
  StreamSubscription? _remoteSub;
  ChatService(this._userRepo);

  @override
  Future<bool> checkExistingChat(String chatId) async {
    final chat = await _isarChatDao.getChatById(chatId);
    return chat != null;
  }

  @override
  Future<String> createChat(List<String> participants) async {
    // Kiểm tra participants hợp lệ
    if (participants.length != 2) {
      return Future.error('Invalid participants count');
    }

    final String currentUserId = _firebaseAuth.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      return Future.error('User not authenticated');
    }

    // Tạo chatId
    final String chatId = ChatUtils.generateChatId(
      participants[0],
      participants[1],
    );
    // Xác định participant (người còn lại không phải current user)
    final String participantId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    if (participantId.isEmpty) {
      return Future.error('Invalid participant');
    }

    // Await getUserById để lấy thông tin participant
    final UserApp? participant = await _userRepo.getUserById(participantId);

    if (participant == null) {
      return Future.error('Participant not found');
    }

    final newChat = ChatItem(
      id: chatId,
      participant: participant,
      message: '',
      time: DateTime.now().toString(),
      unreadCount: 0,
      senderID: currentUserId,
    );

    try {
      // Offline first: tạo chat trong local database trước
      await _isarChatDao.upsert(newChat);

      // Tạo ChatResponse để lưu lên Firebase
      final ChatResponse chatResponse = ChatResponse(
        iD: chatId,
        participants: participants,
        chats: [],
      );

      // Tạo chat trên Firebase
      await _firebaseFirestore
          .collection('Chats')
          .doc(chatId)
          .set(chatResponse.toJson());

      return chatId;
    } catch (e) {
      // Nếu lỗi, xóa chat khỏi local cache
      await _isarChatDao.deleteChat(chatId);
      return Future.error('Failed to create chat: $e');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      // Xóa chat khỏi Firebase trước
      await _firebaseFirestore.collection('Chats').doc(chatId).delete();

      // Chỉ xóa local khi xóa Firebase thành công
      await _isarChatDao.deleteChat(chatId);
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }

  /// 🔥 Bloc sẽ gọi hàm này
  @override
  Stream<List<ChatItem>> loadChats() {
    return _isarChatDao.watchChats();
  }

  void _startRemoteSync() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return;

    _remoteSub ??= _firebaseFirestore
        .collection('Chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen((snapshot) async {
          for (final change in snapshot.docChanges) {
            final data = change.doc.data();
            if (data == null) continue;

            final chatResponse = ChatResponse.fromJson(data);
            final chatItem = await _convertChatResponseToChatItem(
              chatResponse,
              userId,
            );
            if (chatItem == null) continue;
            if (change.type == DocumentChangeType.removed) {
              await _isarChatDao.deleteChat(chatItem.id);
            } else {
              await _isarChatDao.upsert(chatItem);
            }
          }
        });
  }

  /// 🔥 Gọi khi app start / login
  @override
  Future<void> init() async {
    // Thêm: Dispose subscription cũ nếu có (cho user mới)
    await dispose();
    _startRemoteSync();
  }

  @override
  Future<void> dispose() async {
    await _remoteSub?.cancel();
    _remoteSub = null;
  }

  @override
  Future<void> clearCache() async {
    await _isarChatDao.clearAllChats();
  }

  @override
  Future<void> updateChat(String chatId, String newMessage) {
    // TODO: implement updateChat
    throw UnimplementedError();
  }
  // Implementation of the ChatRepo methods

  Future<ChatItem?> _convertChatResponseToChatItem(
    ChatResponse chatResponse,
    String authorId,
  ) async {
    final List<MessageItem> messages = chatResponse.chats;
    final participants_2 = chatResponse.participants;
    final String participantId = participants_2.firstWhere(
      (id) => id != authorId,
      orElse: () => '',
    );
    // get participant details
    final UserApp? participantDetails = await _userRepo.getUserById(
      participantId,
    );
    if (participantDetails == null) {
      return null;
    }

    // ✅ Sắp xếp theo timestamp và lấy message MỚI NHẤT thực sự
    MessageItem lastMessage;
    if (messages.isEmpty) {
      lastMessage = MessageItem(
        content: '',
        isLatest: false,
        senderID: '',
        type: MessageType.Text,
        sendAt: Timestamp.now(),
        isSeen: false,
      );
    } else {
      // Sắp xếp theo sendAt và lấy message cuối cùng
      final sortedMessages = List<MessageItem>.from(messages);
      sortedMessages.sort((a, b) => a.sendAt.compareTo(b.sendAt));
      lastMessage = sortedMessages.last;
    }

    // ✅ Đếm unread count chỉ từ messages của participant
    final int unreadCount =
        messages
            .where((msg) => msg.senderID == participantId && !msg.isSeen)
            .length;

    String contentLastMessage = '';
    if (lastMessage.type == MessageType.Text) {
      contentLastMessage = lastMessage.content;
    } else if (lastMessage.type == MessageType.Image) {
      contentLastMessage = '[Hình ảnh]';
    } else if (lastMessage.type == MessageType.Video) {
      contentLastMessage = '[Video]';
    } else {
      contentLastMessage = '[Tin nhắn khác]';
    }
    return ChatItem(
      id: chatResponse.iD,
      participant: participantDetails,
      message: contentLastMessage,
      time: lastMessage.sendAt.toDate().toString(),
      unreadCount: unreadCount,
      senderID: lastMessage.senderID,
    );
  }
}
