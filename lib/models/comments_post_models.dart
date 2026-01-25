import 'package:maintain_chat_app/utils/convert_time.dart';

class Comment {
  final String? id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? mediaUrl;
  final String? mediaType; // 'image' or 'video'
  final String timeAgo;
  final List<Comment> replies;

  Comment({
    this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    required this.timeAgo,
    this.replies = const [],
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    String? mediaUrl,
    String? mediaType,
    String? timeAgo,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      timeAgo: timeAgo ?? this.timeAgo,
      replies: replies ?? this.replies,
    );
  }
}

class CommentPostResponse {
  final int? id;
  final DateTime createdAt;
  final String? userId;
  final int? postId;
  final String? content;
  final String mediaUrl;
  final String? mediaType;
  final int? parentComment;

  CommentPostResponse({
    this.id,
    required this.createdAt,
    this.userId,
    this.postId,
    this.content,
    this.mediaUrl = '',
    this.mediaType,
    this.parentComment,
  });

  CommentPostResponse copyWith({
    int? id,
    DateTime? createdAt,
    String? userId,
    int? postId,
    String? content,
    String? mediaUrl,
    String? mediaType,
    int? parentComment,
  }) {
    return CommentPostResponse(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      parentComment: parentComment ?? this.parentComment,
    );
  }

  factory CommentPostResponse.fromJson(Map<String, dynamic> json) {
    return CommentPostResponse(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      postId: json['post_id'],
      content: json['content'],
      mediaUrl: json['media_url'] ?? '',
      mediaType: json['mediaType'],
      parentComment: json['parent_comment'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'post_id': postId,
      'content': content,
      'media_url': mediaUrl,
      'mediaType': mediaType,
      'parent_comment': parentComment,
    };

    // Chỉ thêm id nếu có giá trị (cho update), không gửi khi insert
    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}

CommentPostResponse commentToCommentPostResponse(
  Comment comment, {
  String? parentCommentId,
}) {
  return CommentPostResponse(
    createdAt: DateTime.now().toUtc(), // Lưu UTC vào database
    userId: comment.userId,
    postId: int.parse(comment.postId),
    content: comment.content,
    mediaUrl: comment.mediaUrl ?? '',
    mediaType: comment.mediaType,
    parentComment: int.tryParse(parentCommentId ?? ''),
  );
}

Comment commentPostResponseToComment(
  CommentPostResponse response,
  String userName,
  String userAvatar,
) {
  return Comment(
    id: response.id.toString(),
    postId: response.postId.toString(),
    userId: response.userId ?? '',
    userName: userName,
    userAvatar: userAvatar,
    content: response.content ?? '',
    mediaUrl: response.mediaUrl.isNotEmpty ? response.mediaUrl : null,
    mediaType: response.mediaType,
    timeAgo: ConvertTime.formatTimestamp(response.createdAt),
    replies: [], // sẽ được chèn sau
  );
}
