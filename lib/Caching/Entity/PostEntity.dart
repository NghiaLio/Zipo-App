import 'package:isar/isar.dart';
import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';

part 'PostEntity.g.dart';

@Collection()
class PostEntity {
  Id id = Isar.autoIncrement;
  @Index()
  late String postId;
  @Index(unique: true)
  late String clientId;
  @Index()
  late String authorId;
  late String authorName;
  late String authorAvatar;
  late String content;
  late String imageUrl;
  late String timeAgo;
  @Index()
  late DateTime createdAt;
  late int likes;
  late int comments;
  late bool isLiked;

  PostEntity({
    required this.postId,
    required this.clientId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.imageUrl,
    required this.timeAgo,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}

PostItem toPostItem(PostEntity entity) {
  // Tính lại timeAgo từ createdAt mỗi lần query
  final timeAgo = ConvertTime.formatTimestamp(entity.createdAt);

  return PostItem(
    id: entity.postId,
    clientId: entity.clientId,
    authorName: entity.authorName,
    authorAvatar: entity.authorAvatar,
    timeAgo: timeAgo,
    content: entity.content,
    imageUrl: entity.imageUrl,
    likes: entity.likes,
    comments: entity.comments,
    createdAt: entity.createdAt,
    authorId: entity.authorId,
    isLiked: entity.isLiked,
  );
}

PostEntity toPostEntity(PostItem postItem) {
  // postId sẽ là empty string khi chưa có từ Supabase
  final String postId = postItem.id ?? '';

  // Generate unique clientId nếu thiếu
  final String clientId =
      (postItem.clientId == null || postItem.clientId!.isEmpty)
          ? 'client_${DateTime.now().microsecondsSinceEpoch}'
          : postItem.clientId!;

  return PostEntity(
    postId: postId,
    authorId: postItem.authorId,
    clientId: clientId,
    authorName: postItem.authorName,
    authorAvatar: postItem.authorAvatar,
    content: postItem.content,
    imageUrl: postItem.imageUrl,
    timeAgo: postItem.timeAgo,
    createdAt: postItem.createdAt ?? DateTime.now(),
    likes: postItem.likes,
    comments: postItem.comments,
    isLiked: postItem.isLiked,
  );
}
