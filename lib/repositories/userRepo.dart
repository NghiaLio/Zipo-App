import 'package:maintain_chat_app/models/userModels.dart';

abstract class UserRepo {
  Future<void> init();
  Future<void> dispose();
  Future<void> clearCache();
  Future<UserApp?> getUserById(String userId);
  Stream<List<UserApp>> loadAllFriends();
  Future<void> updateUserStatus(bool isOnline);
  Future<UserApp?> getCurrentUser();
  Future<void> updateUserProfile(UserApp user);
  // Future<void> updateUserProfile(String userId, Map<String, dynamic> updates);
}
