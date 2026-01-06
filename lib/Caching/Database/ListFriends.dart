import 'package:isar/isar.dart';
import 'package:maintain_chat_app/Caching/Entity/UserEntity.dart';
import 'package:maintain_chat_app/models/userModels.dart';

class IsarFriendsDao {
  final Isar isar;

  IsarFriendsDao(this.isar);

  Stream<List<UserApp>> watchFriends(String currentUserId) {
    return isar.userEntitys
        .where()
        .watch(fireImmediately: true)
        .map(
          (entities) =>
              entities
                  .where((entity) => entity.uid != currentUserId)
                  .map((item) => fromUserEntity(item))
                  .toList(),
        );
  }

  Future<void> upsert(UserApp user) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.userEntitys.where().uidEqualTo(user.id).findFirst();
      if (existing != null) {
        // Update existing - cập nhật tất cả các trường
        existing.name = user.userName;
        existing.email = user.email;
        existing.phoneNumber = user.phoneNumber;
        existing.avatarUrl = user.avatarUrl ?? '';
        existing.otherName = user.otherName;
        existing.address = user.address;
        existing.isOnline = user.isOnline ?? false;
        existing.requiredAddFriend = user.requiredAddFriend;
        existing.friends = user.friends;
        existing.lastActive = user.lastActive?.toDate();
        existing.pushToken = user.pushToken;
        existing.enableNotify = user.enableNotify;
        await isar.userEntitys.put(existing);
      } else {
        // Insert new
        final entity = toUserEntity(user);
        await isar.userEntitys.put(entity);
      }
    });
  }

  Future<void> clearAllFriends() async {
    await isar.writeTxn(() async {
      final allFriends = await isar.userEntitys.where().findAll();
      for (final friend in allFriends) {
        await isar.userEntitys.delete(friend.id);
      }
    });
  }

  Future<UserApp?> getUserById(String userId) async {
    final entity =
        await isar.userEntitys.where().uidEqualTo(userId).findFirst();
    if (entity != null) {
      return fromUserEntity(entity);
    }
    return null;
  }

  // update user profile
  Future<void> updateUserProfile(UserApp user) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.userEntitys.where().uidEqualTo(user.id).findFirst();
      if (existing != null) {
        existing.name = user.userName;
        existing.email = user.email;
        existing.avatarUrl = user.avatarUrl ?? '';
        existing.isOnline = user.isOnline ?? false;
        await isar.userEntitys.put(existing);
      }
    });
  }
}
