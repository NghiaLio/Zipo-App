import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListPost.dart';
import 'package:maintain_chat_app/models/like_models.dart';
import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/repositories/postRepo.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService implements PostRepo {
  final databasePost = Supabase.instance.client.from('posts');
  final databaseLike = Supabase.instance.client.from('likes_post');
  final databaseComment = Supabase.instance.client.from('comments_post');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserRepo _userRepo;
  PostService(this._userRepo);

  final IsarPost _isarPost = IsarPost(InitializedCaching.isar);

  StreamSubscription? _remoteSub;
  @override
  Future<void> clearCachePosts() {
    return _isarPost.clearAllPosts();
  }

  @override
  Future<void> commentsPost(String postId) {
    // TODO: implement commentsPost
    throw UnimplementedError();
  }

  @override
  Future<void> disposePosts() {
    _remoteSub?.cancel();
    return Future.value();
  }

  @override
  Future<void> initPosts(UserApp user) async {
    _startRemoteSync(user);
  }

  @override
  Future<void> togglelikesPost(String postId, bool isLike) async {
    try {
      if (isLike) {
        // Thêm like
        final Likeitem likeItem = Likeitem(
          userId: _auth.currentUser?.uid ?? '', // Cần truyền user_id hiện tại
          postId: int.parse(postId),
        );
        await databaseLike.insert(likeItem.toJson());
      } else {
        // Xoá like
        await databaseLike
            .delete()
            .eq('post_id', postId)
            .eq(
              'user_id',
              _auth.currentUser?.uid ?? '',
            ); // Cần truyền user_id hiện tại
      }

      // Cập nhật lại số lượng likes trong bảng posts
      final int likesCount = await _getLikesCountForPost(postId);
      final PostItem postItem = await _isarPost.getPostById(postId);
      final PostItem updatedPost = postItem.copyWith(
        likes: likesCount,
        isLiked: isLike,
      );
      await updatePost(postId, updatedPost);
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  @override
  Future<void> createPost(PostItem post) async {
    try {
      // Upsert local trước (optimistic update)
      await _isarPost.upsert(post);

      final PostResponse postResponse = mapPostItemToPostResponse(post);
      log('Creating post with data: ${postResponse.toJson()}');

      // Thêm post vào Supabase
      await databasePost.insert(postResponse.toJson());
      log('Post inserted to Supabase successfully');
    } catch (e) {
      log('Error creating post: $e');
      // Nếu fail, delete khỏi local by createdAt
      if (post.createdAt != null) {
        await _isarPost.deletePostByCreatedAt(post.createdAt!);
      }
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<void> updatePost(String postId, PostItem updatedPost) async {
    try {
      // Update local trước (optimistic update)
      await _isarPost.editPostById(postId, updatedPost);

      final PostResponse postResponse = mapPostItemToPostResponse(updatedPost);
      log('Updating post $postId with data: ${postResponse.toJson()}');

      // Update post trên Supabase
      await databasePost
          .update(postResponse.toJson())
          .eq('id', int.parse(postId));
      log('Post updated to Supabase successfully');
    } catch (e) {
      log('Error updating post: $e');
      throw Exception('Error updating post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      // Delete local trước (optimistic update)
      await _isarPost.deletePostById(postId);

      log('Deleting post $postId');

      // Delete post trên Supabase
      await databasePost.delete().eq('id', int.parse(postId));
      log('Post deleted from Supabase successfully');
    } catch (e) {
      log('Error deleting post: $e');
      throw Exception('Error deleting post: $e');
    }
  }

  @override
  Stream<List<PostItem>> watchAllPosts() {
    return _isarPost.watchPosts();
  }

  // Function to start remote sync from Supabase to local Isar database

  void _startRemoteSync(UserApp user) {
    _remoteSub ??= databasePost.stream(primaryKey: ["id"]).listen((
      event,
    ) async {
      // Xử lý dữ liệu từ Supabase và đồng bộ với cơ sở dữ liệu cục bộ
      // convert sang PostResponse
      final List<PostResponse> posts =
          event.map((json) => PostResponse.fromJson(json)).toList();

      // Sắp xếp lại theo giảm dần của created_at
      posts.sort((a, b) => b.created_at.compareTo(a.created_at));

      // Lấy khoảng 10 bài viết đầu tiên cho cache
      for (int i = 0; i < posts.length && i < 10; i++) {
        final PostResponse postResponse = posts[i];

        // Lấy các bài viết mà userid có trong listFriends của user
        if (!user.friends!.contains(postResponse.user_id) &&
            postResponse.user_id != user.id) {
          log(
            'Bỏ qua bài viết không phải của bạn bè hoặc chính user: ${postResponse.id}',
          );
          continue; // Bỏ qua nếu không phải bài viết của bạn bè hoặc của chính user
        }

        final UserApp? authorPost = await _userRepo.getUserById(
          postResponse.user_id,
        );
        if (authorPost != null) {
          final PostItem post = mapPostResponseToPostItem(
            postResponse,
            authorPost.userName,
            authorPost.avatarUrl ?? '',
            authorPost,
          );
          // Check like status
          final likedPosts = await _getLikedPostIdsByUser(
            _auth.currentUser?.uid ?? '',
          );

          post.isLiked = likedPosts.any((like) => like.postId == post.id);
          // Lưu post vào cơ sở dữ liệu cục bộ
          _isarPost.upsert(post);
          log('Đã lưu bài viết: ${postResponse.id} của ${authorPost.userName}');
        } else {
          log('Không tìm thấy user cho bài viết: ${postResponse.id}');
        }
      }
    });
  }

  // Function map like table to list of PostItem
  Future<List<Likeitem>> _getLikedPostIdsByUser(String userId) async {
    final response = await databaseLike.select().eq('user_id', userId);
    final likePostList =
        response.map((json) => Likeitem.fromJson(json)).toList();
    return likePostList;
  }

  // Functio get number of likes for a post
  Future<int> _getLikesCountForPost(String postId) async {
    final response = await databaseLike.select().eq('post_id', postId);
    return response.length;
  }
}
