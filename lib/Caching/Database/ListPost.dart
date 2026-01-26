import 'package:isar/isar.dart';
import 'package:maintain_chat_app/Caching/Entity/PostEntity.dart';
import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';

class IsarPost {
  final Isar isar;
  IsarPost(this.isar);

  Stream<List<PostItem>> watchPosts() {
    final postEntities = isar.postEntitys
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .asyncMap((entities) async {
          return entities.map((item) => toPostItem(item)).toList();
        });
    return postEntities;
  }

  Future<void> upsert(PostItem post) async {
    await isar.writeTxn(() async {
      await _upsertSinglePost(post);
    });
  }

  Future<void> upsertPosts(List<PostItem> posts) async {
    await isar.writeTxn(() async {
      for (var post in posts) {
        await _upsertSinglePost(post);
      }
    });
  }

  Future<void> _upsertSinglePost(PostItem post) async {
    // Ưu tiên check bằng clientId (unique per post from client)
    if (post.clientId != null && post.clientId!.isNotEmpty) {
      final existingByClientId =
          await isar.postEntitys
              .where()
              .clientIdEqualTo(post.clientId!)
              .findFirst();

      if (existingByClientId != null) {
        // Tìm thấy bằng clientId - Update (bao gồm postId từ remote)
        existingByClientId.postId = post.id ?? existingByClientId.postId;
        existingByClientId.authorName = post.authorName;
        existingByClientId.authorAvatar = post.authorAvatar;
        existingByClientId.content = post.content;
        existingByClientId.imageUrl = post.imageUrl;
        existingByClientId.timeAgo = post.timeAgo;
        existingByClientId.createdAt =
            post.createdAt ?? existingByClientId.createdAt;
        existingByClientId.likes = post.likes;
        existingByClientId.comments = post.comments;
        // Không update isLiked khi sync từ remote, để giữ trạng thái local toggle
        await isar.postEntitys.put(existingByClientId);
        return;
      }
    }

    // Fallback: check bằng postId nếu có và không empty
    if (post.id != null && post.id!.isNotEmpty) {
      final existingById =
          await isar.postEntitys.where().postIdEqualTo(post.id!).findFirst();

      if (existingById != null) {
        // Update existing by postId
        existingById.clientId = post.clientId ?? existingById.clientId;
        existingById.authorName = post.authorName;
        existingById.authorAvatar = post.authorAvatar;
        existingById.content = post.content;
        existingById.imageUrl = post.imageUrl;
        existingById.timeAgo = post.timeAgo;
        existingById.createdAt = post.createdAt ?? existingById.createdAt;
        existingById.likes = post.likes;
        existingById.comments = post.comments;
        // Không update isLiked khi sync từ remote
        await isar.postEntitys.put(existingById);
        return;
      }
    }

    // Insert new
    final entity = toPostEntity(post);
    await isar.postEntitys.put(entity);
  }

  // get post by id
  Future<PostItem> getPostById(String postId) async {
    final entity =
        await isar.postEntitys.where().postIdEqualTo(postId).findFirst();
    if (entity != null) {
      return toPostItem(entity);
    } else {
      throw Exception('Post with id $postId not found');
    }
  }

  // edit post by id
  Future<void> editPostById(String postId, PostItem updatedPost) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.postEntitys.where().postIdEqualTo(postId).findFirst();
      if (existing != null) {
        existing.authorName = updatedPost.authorName;
        existing.authorAvatar = updatedPost.authorAvatar;
        existing.content = updatedPost.content;
        existing.timeAgo = updatedPost.timeAgo;
        existing.likes = updatedPost.likes;
        existing.comments = updatedPost.comments;
        existing.isLiked = updatedPost.isLiked;
        await isar.postEntitys.put(existing);
      }
    });
  }

  // delete post by id
  Future<void> deletePostById(String postId) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.postEntitys.where().postIdEqualTo(postId).findFirst();
      if (existing != null) {
        await isar.postEntitys.delete(existing.id);
      }
    });
  }

  // delete post by createdAt
  Future<void> deletePostByCreatedAt(DateTime createdAt) async {
    await isar.writeTxn(() async {
      final existing =
          await isar.postEntitys
              .where()
              .createdAtEqualTo(createdAt)
              .findFirst();
      if (existing != null) {
        await isar.postEntitys.delete(existing.id);
      }
    });
  }

  // clear posts
  Future<void> clearAllPosts() async {
    await isar.writeTxn(() async {
      await isar.postEntitys.clear();
    });
  }
}
