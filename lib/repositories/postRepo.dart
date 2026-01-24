import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/models/userModels.dart';

abstract class PostRepo {
  Future<void> initPosts(UserApp user);
  Future<void> disposePosts();
  Future<void> clearCachePosts();
  Stream<List<PostItem>> watchAllPosts();
  Future<void> createPost(PostItem post);
  Future<void> updatePost(String postId, PostItem updatedPost);
  Future<void> deletePost(String postId);
  Future<void> togglelikesPost(String postId, bool isLike);
  Future<void> commentsPost(String postId);
}
