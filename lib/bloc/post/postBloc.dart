// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/post/postEvent.dart';
import 'package:maintain_chat_app/bloc/post/postState.dart';
import 'package:maintain_chat_app/models/comments_post_models.dart';
import 'package:maintain_chat_app/models/post_models.dart';
import 'package:maintain_chat_app/repositories/postRepo.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepo postRepository;
  StreamSubscription<List<PostItem>>? _postsSubscription;

  PostBloc({required this.postRepository}) : super(const PostState()) {
    on<LoadPosts>(_onLoadPosts);
    on<PostsUpdatedEvent>(_onPostsUpdated);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<ToggleLike>(_onToggleLike);
    on<LoadCommentForPost>(_onLoadCommentForPost);
    on<CommentOnPost>(_onCommentOnPost);
    on<DeleteComment>(_onDeleteComment);
    on<UpdateComment>(_onUpdateComment);
    on<LoadMorePosts>(_onLoadMorePosts);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Cancel previous subscription if exists
      await _postsSubscription?.cancel();

      // Listen to the stream from repository
      _postsSubscription = postRepository.watchAllPosts().listen(
        (posts) {
          // When stream emits new data, add PostsUpdatedEvent
          add(PostsUpdatedEvent(posts));
        },
        onError: (error) {
          add(PostsUpdatedEvent([])); // Emit empty list on error
        },
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onPostsUpdated(
    PostsUpdatedEvent event,
    Emitter<PostState> emit,
  ) async {
    print('📮 PostsUpdated: Nhận được ${event.posts.length} bài viết');
    for (var post in event.posts) {
      print(
        '   - Post ID: ${post.id}, Author: ${post.authorName}, Time: ${post.timeAgo}',
      );
    }
    emit(state.copyWith(posts: event.posts, isLoading: false));
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await postRepository.createPost(event.post);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Tạo PostItem với thông tin cập nhật
      final currentPost = state.posts.firstWhere((p) => p.id == event.postId);
      final updatedPost = PostItem(
        id: currentPost.id,
        clientId: currentPost.clientId,
        authorId: currentPost.authorId,
        authorName: currentPost.authorName,
        authorAvatar: currentPost.authorAvatar,
        timeAgo: currentPost.timeAgo,
        createdAt: currentPost.createdAt,
        content: event.updatedContent,
        imageUrl: event.mediaUrl ?? currentPost.imageUrl,
        likes: currentPost.likes,
        comments: currentPost.comments,
      );

      await postRepository.updatePost(event.postId, updatedPost);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await postRepository.deletePost(event.postId);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onToggleLike(ToggleLike event, Emitter<PostState> emit) async {
    try {
      await postRepository.togglelikesPost(event.postId, event.isLike);
      // Repository update local cache, stream sẽ emit và update UI
    } catch (e) {
      // Nếu fail, emit error, và có thể revert nếu cần, nhưng vì stream đã emit update, khó revert
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadCommentForPost(
    LoadCommentForPost event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final comments = await postRepository.getAllComments(event.postId);
      final totalComments = _countTotalComments(comments);
      emit(
        state.copyWith(
          commentsOnPost: comments,
          totalCommentOnPost: totalComments,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCommentOnPost(
    CommentOnPost event,
    Emitter<PostState> emit,
  ) async {
    try {
      if (event.parentCommentId != null) {
        // Nếu là reply - cần tìm parent comment trong tree và thêm reply
        final updatedComments = _addReplyToCommentTree(
          state.commentsOnPost,
          event.parentCommentId!,
          event.newComment,
        );
        emit(
          state.copyWith(
            commentsOnPost: updatedComments,
            totalCommentOnPost: state.totalCommentOnPost + 1,
            errorMessage: null,
          ),
        );
      } else {
        // comment bình thường
        emit(
          state.copyWith(
            commentsOnPost: [...state.commentsOnPost, event.newComment],
            totalCommentOnPost: state.totalCommentOnPost + 1,
            isLoading: false,
            errorMessage: null,
          ),
        );
      }
      await postRepository.commentsPost(
        event.newComment,
        event.parentCommentId,
      );
    } catch (e) {
      // Nếu fail, emit error và set isLoading = false
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Helper function để thêm reply vào đúng vị trí trong comment tree
  List<Comment> _addReplyToCommentTree(
    List<Comment> comments,
    String parentId,
    Comment newReply,
  ) {
    return comments.map((comment) {
      // Nếu comment này là parent
      if (comment.id == parentId) {
        return comment.copyWith(replies: [...comment.replies, newReply]);
      }
      // Nếu không phải, kiểm tra trong replies của comment này (recursive)
      else if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _addReplyToCommentTree(comment.replies, parentId, newReply),
        );
      }
      // Nếu không tìm thấy, trả về comment gốc
      return comment;
    }).toList();
  }

  int _countTotalComments(List<Comment> comments) {
    int total = 0;
    for (var comment in comments) {
      total += 1;
      total += _countTotalComments(comment.replies);
    }
    return total;
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<PostState> emit,
  ) async {
    try {
      // Optimistic update: xóa comment khỏi state ngay lập tức
      final commentToDelete = _findCommentById(
        state.commentsOnPost,
        event.commentId,
      );
      final countToRemove =
          commentToDelete != null
              ? 1 + _countTotalComments(commentToDelete.replies)
              : 0;

      final updatedComments = _removeCommentFromTree(
        state.commentsOnPost,
        event.commentId,
      );
      emit(
        state.copyWith(
          commentsOnPost: updatedComments,
          totalCommentOnPost: state.totalCommentOnPost - countToRemove,
          errorMessage: null,
        ),
      );

      // Gọi API xóa
      await postRepository.deleteComment(event.commentId, event.postId);
    } catch (e) {
      // Nếu lỗi, reload lại comments từ remote
      try {
        final comments = await postRepository.getAllComments(event.postId);
        emit(
          state.copyWith(commentsOnPost: comments, errorMessage: e.toString()),
        );
      } catch (_) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _onUpdateComment(
    UpdateComment event,
    Emitter<PostState> emit,
  ) async {
    try {
      // Optimistic update: cập nhật comment trong state ngay lập tức
      final updatedComments =
          state.commentsOnPost.map((c) {
            if (c.id == event.commentId) {
              return c.copyWith(
                content: event.newContent,
                mediaUrl: event.mediaUrl,
                mediaType: event.mediaType,
              );
            }
            return c;
          }).toList();
      emit(state.copyWith(commentsOnPost: updatedComments, errorMessage: null));

      // Gọi API cập nhật
      await postRepository.updateComment(
        event.commentId,
        event.postId,
        event.newContent,
        event.mediaUrl,
        event.mediaType,
      );
    } catch (e) {
      // Nếu lỗi, reload lại comments từ remote
      try {
        final comments = await postRepository.getAllComments(event.postId);
        emit(
          state.copyWith(commentsOnPost: comments, errorMessage: e.toString()),
        );
      } catch (_) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Comment? _findCommentById(List<Comment> comments, String id) {
    for (var comment in comments) {
      if (comment.id == id) return comment;
      final found = _findCommentById(comment.replies, id);
      if (found != null) return found;
    }
    return null;
  }

  List<Comment> _removeCommentFromTree(List<Comment> comments, String id) {
    return comments
        .where((c) => c.id != id)
        .map((c) => c.copyWith(replies: _removeCommentFromTree(c.replies, id)))
        .toList();
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<PostState> emit,
  ) async {
    try {
      await postRepository.loadMorePosts(event.user, event.lastCreatedAt);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
