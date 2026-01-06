import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListFriends.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';

class UserService implements UserRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  StreamSubscription? _remoteSub;
  final IsarFriendsDao _isarFriendsDao = IsarFriendsDao(
    InitializedCaching.isar,
  );

  @override
  Future<UserApp?> getUserById(String userId) {
    return _firebaseFirestore.collection('UserData').doc(userId).get().then((
      doc,
    ) {
      if (doc.exists) {
        return UserApp.fromJson(doc.data()!);
      } else {
        return null;
      }
    });
  }

  @override
  Stream<List<UserApp>> loadAllFriends() {
    return _isarFriendsDao.watchFriends(_firebaseAuth.currentUser!.uid);
  }

  @override
  Future<void> dispose() async {
    await _remoteSub?.cancel();
    _remoteSub = null;
    await _isarFriendsDao.clearAllFriends();
    await updateUserStatus(false);
  }

  @override
  Future<void> init() async {
    await dispose();
    await updateUserStatus(true);
    _startRemoteSync();
  }

  void _startRemoteSync() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return;

    _remoteSub ??= _firebaseFirestore
        .collection('UserData')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            UserApp user = UserApp.fromJson(
              snapshot.data() as Map<String, dynamic>,
            );
            final List<String>? listFriends = user.friends;

            // Clear toàn bộ danh sách friends cũ trước khi sync
            await _isarFriendsDao.clearAllFriends();

            if (listFriends != null && listFriends.isNotEmpty) {
              List<UserApp?> parseList = await Future.wait(
                listFriends.map((id) async => await getUserById(id)),
              );
              // Insert danh sách friends mới
              for (final friend in parseList.whereType<UserApp>()) {
                await _isarFriendsDao.upsert(friend);
              }
            }
          }
        });
  }

  @override
  Future<void> clearCache() async {
    await _isarFriendsDao.clearAllFriends();
  }

  @override
  Future<void> updateUserStatus(bool isOnline) async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return;
      }

      final docRef = _firebaseFirestore.collection('UserData').doc(userId);

      await docRef.update({
        'isOnline': isOnline,
        'lastActive': Timestamp.fromDate(DateTime.now()),
      });

    } catch (e) {
      return;
    }
  }

  @override
  Future<UserApp?> getCurrentUser() async {
    try {
      final user = await _isarFriendsDao.getUserById(
        _firebaseAuth.currentUser!.uid,
      );
      return user;
    } catch (e) {
      throw Exception('Error getting current user from cache: $e');
      // return null;
    }
  }

  @override
  Future<void> updateUserProfile(UserApp user) async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null || userId != user.id) {
        throw Exception('Unauthorized to update this user profile');
      }


      // Update to Firestore
      await _firebaseFirestore.collection('UserData').doc(userId).update({
        'userName': user.userName,
        'phoneNumber': user.phoneNumber,
        'otherName': user.otherName,
        'address': user.address,
        'avatar': user.avatarUrl,
      });


      // Update to local Isar cache
      await _isarFriendsDao.upsert(user);

    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // @override
  // Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) {}
}
