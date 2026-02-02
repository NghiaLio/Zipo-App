import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListFriends.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/repositories/notificationRepo.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService implements NotificationRepo {
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final IsarFriendsDao _isarFriendsDao = IsarFriendsDao(
    InitializedCaching.isar,
  );

  @override
  Future<void> saveFirebaseMessagingToken(String userId) async {
    try {
      await fMessaging.requestPermission();
      // print(x.authorizationStatus);
      await fMessaging.getToken().then((token) async {
        if (token != null) {
          log('token: $token');
          // Save the token to your server or database associated with the userId
          await firestore.collection('UserData').doc(userId).update({
            'pushToken': FieldValue.arrayUnion([token]),
          });

          // Caching token locally
          await _isarFriendsDao.updatePushToken(userId, token);
        }
      });
    } catch (e) {
      throw Exception('Error getting firebase messaging token: $e');
    }
  }

  @override
  Future<void> sendNotification({
    required UserApp receiverUser,
    required UserApp senderUser,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // ben nhan co cho phep nhan thong bao hay khong tu ben gui hay ko
      final bool isEnableNotify = receiverUser.enableNotify!.contains(
        senderUser.id,
      );
      if (!isEnableNotify) {
        log('Notifications disabled for this user');
        return;
      }

      // Get the token list
      List<String> receiverTokens = [];
      if (receiverUser.pushToken is List) {
        receiverTokens =
            (receiverUser.pushToken as List)
                .map((token) => token.toString())
                .where((token) => token.isNotEmpty)
                .toList();
      } else if (receiverUser.pushToken != null) {
        final token = receiverUser.pushToken.toString();
        if (token.isNotEmpty) {
          receiverTokens.add(token);
        }
      }

      if (receiverTokens.isEmpty) {
        log('No push tokens available for receiver');
        return;
      }

      final String? keyServer = await getServerKey();
      if (keyServer == null) {
        log('Failed to get server key');
        return;
      }

      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $keyServer',
      };

      // Danh sách các token không hợp lệ cần xóa
      List<String> invalidTokens = [];

      // Gửi thông báo đến tất cả các token
      log('Sending notification to ${receiverTokens.length} device(s)');

      for (final receiverToken in receiverTokens) {
        try {
          final requestBody = {
            "message": {
              "token": receiverToken,
              "notification": {
                "title": senderUser.userName,
                "body": body,
              },
              "data": {"senderID": senderUser.id},
            },
          };

          log('Sending to token: ${receiverToken.substring(0, 20)}...');

          final response = await Dio().post(
            dotenv.env['URL_SEND_NOTIFICATION']!,
            options: Options(
              headers: headers,
              validateStatus: (status) => true,
            ),
            data: jsonEncode(requestBody),
          );

          if (response.statusCode == 200) {
            log('✓ Notification sent successfully to token');
          } else if (response.statusCode == 404) {
            // Token không hợp lệ (thiết bị đã gỡ app hoặc token hết hạn)
            log('✗ Invalid token (UNREGISTERED), marking for removal');
            invalidTokens.add(receiverToken);
          } else {
            log(
              '✗ Failed to send to token: ${response.statusCode} - ${response.data}',
            );
          }
        } catch (e) {
          log('Error sending to token: $e');
          // Tiếp tục gửi đến các token khác
        }
      }

      // Xóa các token không hợp lệ khỏi Firestore
      if (invalidTokens.isNotEmpty) {
        try {
          log(
            'Removing ${invalidTokens.length} invalid token(s) from user ${receiverUser.id}',
          );
          await firestore.collection('UserData').doc(receiverUser.id).update({
            'pushToken': FieldValue.arrayRemove(invalidTokens),
          });

          // Cập nhật cache local nếu có
          await _isarFriendsDao.removePushTokens(
            receiverUser.id!,
            invalidTokens,
          );
        } catch (e) {
          log('Failed to remove invalid tokens: $e');
        }
      }
    } catch (e) {
      log('Error sending notification: $e');
      // Don't throw - just log the error so app continues to work
    }
  }

  @override
  Future<void> toggleNotification(String userId, bool isNotification) async {
    try {
      final currentUserId = _firebaseAuth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      await _isarFriendsDao.toggleNotification(currentUserId, isNotification);

      if (isNotification) {
        // add friend - bật thông báo
        await firestore.collection('UserData').doc(currentUserId).update({
          'enableNotify': FieldValue.arrayUnion([userId]),
        });
        await firestore.collection('UserData').doc(userId).update({
          'enableNotify': FieldValue.arrayUnion([currentUserId]),
        });
      } else {
        // remove friend - tắt thông báo
        await firestore.collection('UserData').doc(currentUserId).update({
          'enableNotify': FieldValue.arrayRemove([userId]),
        });
        await firestore.collection('UserData').doc(userId).update({
          'enableNotify': FieldValue.arrayRemove([currentUserId]),
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String?> getServerKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
      // 'https://www.googleapis.com/auth/spreadsheets'
    ];

    final responeFile = await rootBundle.loadString(
      'assets/chatapp-c4dc9-firebase-adminsdk-fbsvc-2d04f2d28f.json',
    );
    final Map<String, dynamic> readServiceAccountCredentials = json.decode(
      responeFile,
    );
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(readServiceAccountCredentials),
      scopes,
    );
    final accessServerkey = client.credentials.accessToken.data;
    return accessServerkey;
  }
}
