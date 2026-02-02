import 'package:maintain_chat_app/models/userModels.dart';

abstract class NotificationRepo {
  Future<void> toggleNotification(String userId, bool isNotification);
  Future<void> saveFirebaseMessagingToken(String userId);
  Future<String?> getServerKey();
  Future<void> sendNotification({
    required UserApp senderUser,
    required UserApp receiverUser,
    required String title,
    required String body,
    Map<String, String>? data,
  });
}