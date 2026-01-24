// ignore_for_file: file_names

import 'package:isar/isar.dart';
import 'package:maintain_chat_app/Caching/Entity/MessageEntity.dart';
import 'package:maintain_chat_app/Caching/Entity/PostEntity.dart';
import 'package:path_provider/path_provider.dart';

import '../Entity/ChatEntity.dart';
import '../Entity/UserEntity.dart';

class InitializedCaching {
  static late Isar isar;

  static Future<void> initializeListChat() async {
    // Kiểm tra xem Isar đã được khởi tạo chưa
    if (Isar.instanceNames.isNotEmpty) {
      isar = Isar.getInstance()!;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      ChatEntitySchema,
      UserEntitySchema,
      MessageEntitySchema,
      PostEntitySchema
    ], directory: dir.path);
  }
}
