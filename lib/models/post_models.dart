// ignore_for_file: non_constant_identifier_names

import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';

class PostItem {
  UserApp? user;
  final String? id;
  final String? clientId;
  final String authorName;
  final String authorId;
  final String authorAvatar;
  final String timeAgo;
  final DateTime? createdAt;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  bool isLiked;

  PostItem({
    this.user,
    this.id,
    this.clientId,
    this.isLiked = false,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    this.createdAt,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });

  PostItem copyWith({
    UserApp? user,
    String? id,
    String? clientId,
    String? authorName,
    String? authorAvatar,
    String? timeAgo,
    DateTime? createdAt,
    String? content,
    String? imageUrl,
    int? likes,
    int? comments,
    bool? isLiked,
    String? authorId,
  }) {
    return PostItem(
      user: user ?? this.user,
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      timeAgo: timeAgo ?? this.timeAgo,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class PostResponse {
  final int? id;
  final String user_id;
  final String content;
  final String media_url;
  final String created_at;
  final String? clientId;
  final int total_likes;
  final int total_comments;

  PostResponse({
    this.id,
    this.clientId,
    required this.user_id,
    required this.content,
    required this.media_url,
    required this.created_at,
    required this.total_likes,
    required this.total_comments,
  });

  PostResponse copyWith({
    int? id,
    String? user_id,
    String? content,
    String? media_url,
    String? created_at,
    String? clientId,
    int? total_likes,
    int? total_comments,
  }) {
    return PostResponse(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      content: content ?? this.content,
      media_url: media_url ?? this.media_url,
      created_at: created_at ?? this.created_at,
      clientId: clientId ?? this.clientId,
      total_likes: total_likes ?? this.total_likes,
      total_comments: total_comments ?? this.total_comments,
    );
  }

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      user_id: json['user_id'],
      content: json['content'] ?? '',
      media_url: json['media_url'] ?? '',
      created_at: json['created_at'] ?? '',
      total_likes: json['total_likes'] ?? 0,
      total_comments: json['total_comments'] ?? 0,
      clientId: json['client_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'content': content,
      'media_url': media_url,
      'created_at': created_at,
      'client_id': clientId,
      'total_likes': total_likes,
      'total_comments': total_comments,
    };
  }
}

PostItem mapPostResponseToPostItem(
  PostResponse postResponse,
  String authorName,
  String authorAvatar,
  UserApp? user,
) {
  final createdAt = DateTime.parse(postResponse.created_at);
  final timeAgo = ConvertTime.formatTimestamp(createdAt);
  return PostItem(
    id: postResponse.id.toString(),
    user: user,
    authorId: postResponse.user_id,
    authorName: authorName,
    authorAvatar: authorAvatar,
    timeAgo: timeAgo,
    createdAt: createdAt,
    content: postResponse.content,
    imageUrl: postResponse.media_url,
    likes: postResponse.total_likes,
    comments: postResponse.total_comments,
    clientId: postResponse.clientId,
  );
}

PostResponse mapPostItemToPostResponse(PostItem postItem) {
  return PostResponse(
    user_id: postItem.authorId,
    content: postItem.content,
    media_url: postItem.imageUrl,
    created_at: postItem.createdAt?.toIso8601String() ?? '',
    total_likes: postItem.likes,
    total_comments: postItem.comments,
    clientId: postItem.clientId,
  );
}
