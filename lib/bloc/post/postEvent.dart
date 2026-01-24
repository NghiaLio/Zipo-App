import 'package:maintain_chat_app/models/post_models.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostEvent {}

class PostsUpdatedEvent extends PostEvent {
  final List<PostItem> posts;

  PostsUpdatedEvent(this.posts);

  @override
  List<Object?> get props => [posts];
}

class DeletePost extends PostEvent {
  final String postId;

  DeletePost(this.postId);
  @override
  List<Object?> get props => [postId];
}

class RefreshPosts extends PostEvent {}

class CreatePost extends PostEvent {
  final PostItem post;

  CreatePost(this.post);
  @override
  List<Object?> get props => [post];
}

class UpdatePost extends PostEvent {
  final String postId;
  final String updatedContent;
  final String? mediaUrl;

  UpdatePost(this.postId, this.updatedContent, this.mediaUrl);
  @override
  List<Object?> get props => [postId, updatedContent, mediaUrl];
}

class ToggleLike extends PostEvent {
  final String postId;
  final bool isLike;

  ToggleLike(this.postId, this.isLike);
  @override
  List<Object?> get props => [postId, isLike];
}
