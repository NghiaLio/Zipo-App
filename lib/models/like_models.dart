class Likeitem {
  final int postId;
  final String userId;

  Likeitem({required this.postId, required this.userId});

  Likeitem copyWith({int? postId, String? userId}) {
    return Likeitem(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'post_id': postId, 'user_id': userId};
  }

  factory Likeitem.fromJson(Map<String, dynamic> json) {
    return Likeitem(postId: json['post_id'], userId: json['user_id']);
  }
}
