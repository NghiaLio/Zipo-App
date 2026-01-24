import 'package:maintain_chat_app/models/userModels.dart';

abstract class UserRepo {
  Future<void> init();
  Future<void> dispose();
  Future<void> clearCache();
  Future<UserApp?> getUserById(String userId);
  Stream<List<UserApp>> loadAllFriends();
  Future<List<UserApp>> loadFriendRequest();
  Future<void> updateUserStatus(bool isOnline);
  Future<UserApp?> getCurrentUser();
  Future<void> updateUserProfile(UserApp user);
  Future<List<UserApp>> searchUsersByEmailOrNumberPhone(String query);
  Future<void> toggleFriendRequest(String friendId, bool isSendRequest);
  Future<void> rejectFriendRequest({
    required String senderId,
    required String receiverId,
  });
  Future<void> toggleFriend(String friendId, bool isFriend);
  // Future<void> updateUserProfile(String userId, Map<String, dynamic> updates);
}
