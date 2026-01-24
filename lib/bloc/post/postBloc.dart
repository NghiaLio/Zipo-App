import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/post/postEvent.dart';
import 'package:maintain_chat_app/bloc/post/postState.dart';
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

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
