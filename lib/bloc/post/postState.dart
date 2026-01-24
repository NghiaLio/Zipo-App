import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/post_models.dart';

class PostState extends Equatable{

  final List<PostItem> posts;
  final bool isLoading;
  final String? errorMessage;
  final bool? deleteState;

  const PostState({this.posts = const [], this.isLoading = false, this.errorMessage, this.deleteState});

  PostState copyWith({List<PostItem>? posts, bool? isLoading, String? errorMessage, bool? deleteState}) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      deleteState: deleteState ?? this.deleteState,
    );
  }
  @override
  List<Object?> get props => [posts, isLoading, errorMessage, deleteState];
}