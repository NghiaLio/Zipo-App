import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintain_chat_app/Caching/Database/Init.dart';
import 'package:maintain_chat_app/Caching/Database/ListPost.dart';
import 'package:maintain_chat_app/models/comments_post_models.dart';
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
  Future<void> clearCachePosts() async {
    await _isarPost.clearAllPosts();
  }

  @override
  Future<void> commentsPost(Comment comment, String? parentCommentId) async {
    try {
      // Thêm comment vào Supabase - không cache local
      final commentResponse = commentToCommentPostResponse(
        comment,
        parentCommentId: parentCommentId,
      );
      await databaseComment.insert(commentResponse.toJson());
      log('Comment inserted to Supabase successfully');
      // cập nhật số lượng comment trong bảng posts
      final PostItem postItem = await _isarPost.getPostById(
        comment.postId.toString(),
      );
      final updatedPost = postItem.copyWith(comments: postItem.comments + 1);
      await updatePost(comment.postId.toString(), updatedPost);
    } catch (e) {
      throw Exception('Error creating comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String commentId, String postId) async {
    try {
      await databaseComment.delete().eq('id', int.parse(commentId));
      log('Comment deleted successfully');

      // cập nhật số lượng comment trong bảng posts
      final PostItem postItem = await _isarPost.getPostById(postId);
      final updatedPost = postItem.copyWith(comments: postItem.comments - 1);
      await updatePost(postId, updatedPost);
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  @override
  Future<void> updateComment(
    String commentId,
    String postId,
    String newContent,
    String? mediaUrl,
    String? mediaType,
  ) async {
    try {
      await databaseComment
          .update({
            'content': newContent,
            'media_url': mediaUrl ?? '',
            'mediaType': mediaType,
          })
          .eq('id', int.parse(commentId));
      log('Comment updated successfully');
    } catch (e) {
      throw Exception('Error updating comment: $e');
    }
  }

  @override
  Future<List<Comment>> getAllComments(String postId) async {
    try {
      // get comments from remote
      final response = await databaseComment.select().eq(
        'post_id',
        int.parse(postId),
      );

      final comments =
          response.map((json) => CommentPostResponse.fromJson(json)).toList();

      // Build map of all comments with user info
      final Map<int, Comment> commentMap = {};

      for (var commentResponse in comments) {
        final user = await _userRepo.getUserById(commentResponse.userId ?? '');
        if (user != null) {
          final commentModel = commentPostResponseToComment(
            commentResponse,
            user.userName,
            user.avatarUrl ?? '',
          );
          commentMap[commentResponse.id!] = commentModel;
        }
      }

      // Build tree structure: attach replies to parents
      final List<Comment> rootComments = [];
      final Map<int, List<Comment>> childrenMap = {};

      // Group children by parent
      for (var commentResponse in comments) {
        if (commentResponse.parentComment != null) {
          childrenMap.putIfAbsent(commentResponse.parentComment!, () => []);
          final comment = commentMap[commentResponse.id];
          if (comment != null) {
            childrenMap[commentResponse.parentComment!]!.add(comment);
          }
        }
      }

      // Recursively attach children to parents
      void attachChildren(Comment comment) {
        final commentId = int.tryParse(comment.id ?? '');
        if (commentId != null && childrenMap.containsKey(commentId)) {
          final children = childrenMap[commentId]!;
          // Attach children recursively
          for (var child in children) {
            attachChildren(child);
          }
          // Update comment with children
          final updatedComment = comment.copyWith(replies: children);
          commentMap[commentId] = updatedComment;
        }
      }

      // Find root comments (no parent) and attach their children
      for (var commentResponse in comments) {
        if (commentResponse.parentComment == null) {
          var rootComment = commentMap[commentResponse.id!];
          if (rootComment != null) {
            attachChildren(rootComment);
            // Get updated version with attached children
            rootComment = commentMap[commentResponse.id!]!;
            rootComments.add(rootComment);
          }
        }
      }

      return rootComments;
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
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

  @override
  Future<void> loadMorePosts(UserApp user, DateTime lastCreatedAt) async {
    try {
      // Fetch posts older than lastCreatedAt
      final response = await databasePost
          .select()
          .lt('created_at', lastCreatedAt.toIso8601String())
          .order('created_at', ascending: false)
          .limit(10);

      final List<PostResponse> postResponses =
          response.map((json) => PostResponse.fromJson(json)).toList();

      List<PostItem> postsToCache = [];

      for (var postResponse in postResponses) {
        // Lọc theo listFriends tương tự sync
        if (!user.friends!.contains(postResponse.user_id) &&
            postResponse.user_id != user.id) {
          continue;
        }

        final authorPost = await _userRepo.getUserById(postResponse.user_id);
        if (authorPost != null) {
          final post = mapPostResponseToPostItem(
            postResponse,
            authorPost.userName,
            authorPost.avatarUrl ?? '',
            authorPost,
          );

          // Check like status
          final likedPosts = await _getLikedPostIdsByUser(
            _auth.currentUser?.uid ?? '',
          );
          post.isLiked = likedPosts.any(
            (like) => like.postId == int.parse(post.id ?? '0'),
          );

          postsToCache.add(post);
        }
      }

      if (postsToCache.isNotEmpty) {
        await _isarPost.upsertPosts(postsToCache);
        log('Loaded more ${postsToCache.length} posts into cache');
      }
    } catch (e) {
      log('Error loading more posts: $e');
    }
  }

  void _startRemoteSync(UserApp user) {
    _remoteSub ??= databasePost.stream(primaryKey: ["id"]).listen((
      event,
    ) async {
      final List<PostResponse> posts =
          event.map((json) => PostResponse.fromJson(json)).toList();

      posts.sort((a, b) => b.created_at.compareTo(a.created_at));

      List<PostItem> latestPosts = [];

      // Lấy 10 bài viết mới nhất để sync tự động
      for (int i = 0; i < posts.length && i < 10; i++) {
        final postResponse = posts[i];

        if (!user.friends!.contains(postResponse.user_id) &&
            postResponse.user_id != user.id) {
          continue;
        }

        final authorPost = await _userRepo.getUserById(postResponse.user_id);
        if (authorPost != null) {
          final post = mapPostResponseToPostItem(
            postResponse,
            authorPost.userName,
            authorPost.avatarUrl ?? '',
            authorPost,
          );

          final likedPosts = await _getLikedPostIdsByUser(
            _auth.currentUser?.uid ?? '',
          );
          post.isLiked = likedPosts.any(
            (like) => like.postId == int.parse(post.id ?? '0'),
          );

          latestPosts.add(post);
        }
      }

      if (latestPosts.isNotEmpty) {
        await _isarPost.upsertPosts(latestPosts);
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
