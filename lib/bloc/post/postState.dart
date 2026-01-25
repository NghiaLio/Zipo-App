import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/comments_post_models.dart';
import 'package:maintain_chat_app/models/post_models.dart';

class PostState extends Equatable{

  final List<PostItem> posts;
  final List<Comment> commentsOnPost;
  final int totalCommentOnPost;
  final bool isLoading;
  final String? errorMessage;
  final bool? deleteState;

  const PostState({this.posts = const [], this.commentsOnPost = const [], this.totalCommentOnPost = 0, this.isLoading = false, this.errorMessage, this.deleteState});

  PostState copyWith({List<PostItem>? posts, List<Comment>? commentsOnPost, int? totalCommentOnPost, bool? isLoading, String? errorMessage, bool? deleteState}) {
    return PostState(
      posts: posts ?? this.posts,
      commentsOnPost: commentsOnPost ?? this.commentsOnPost,
      totalCommentOnPost: totalCommentOnPost ?? this.totalCommentOnPost,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      deleteState: deleteState ?? this.deleteState,
    );
  }
  @override
  List<Object?> get props => [posts, commentsOnPost, totalCommentOnPost, isLoading, errorMessage, deleteState];
}