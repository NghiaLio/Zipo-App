import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
import 'package:isar/isar.dart';
import 'package:maintain_chat_app/models/userModels.dart';

part 'UserEntity.g.dart';

@Collection()
class UserEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String name;
  late String email;
  late String? phoneNumber;
  late String avatarUrl;
  late String? otherName;
  late String? address;
  late bool isOnline;
  late List<String>? requiredAddFriend;
  late List<String>? friends;
  DateTime? lastActive;
  late String? pushToken;
  late List<String>? enableNotify;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.avatarUrl,
    this.otherName,
    this.address,
    required this.isOnline,
    this.requiredAddFriend,
    this.friends,
    this.lastActive,
    this.pushToken,
    this.enableNotify,
  });
}

UserEntity toUserEntity(UserApp user) {
  return UserEntity(
    uid: user.id,
    name: user.userName,
    email: user.email,
    phoneNumber: user.phoneNumber,
    avatarUrl: user.avatarUrl ?? '',
    otherName: user.otherName,
    address: user.address,
    isOnline: user.isOnline ?? false,
    requiredAddFriend: user.requiredAddFriend,
    friends: user.friends,
    lastActive: user.lastActive?.toDate(),
    pushToken: user.pushToken,
    enableNotify: user.enableNotify,
  );
}

UserApp fromUserEntity(UserEntity entity) {
  // Calculate if user is online based on lastActive timestamp
  bool isActuallyOnline = entity.isOnline;
  if (entity.lastActive != null) {
    final now = DateTime.now();
    final difference = now.difference(entity.lastActive!);
    // Consider offline if lastActive > 2 minutes ago
    if (difference.inMinutes > 2) {
      isActuallyOnline = false;
    }
  } else {
    // No lastActive means offline
    isActuallyOnline = false;
  }

  return UserApp(
    id: entity.uid.toString(),
    userName: entity.name,
    email: entity.email,
    phoneNumber: entity.phoneNumber,
    avatarUrl: entity.avatarUrl,
    otherName: entity.otherName,
    address: entity.address,
    isOnline: isActuallyOnline,
    requiredAddFriend: entity.requiredAddFriend,
    friends: entity.friends,
    lastActive:
        entity.lastActive != null
            ? Timestamp.fromDate(entity.lastActive!)
            : null,
    pushToken: entity.pushToken,
    enableNotify: entity.enableNotify,
  );
}
