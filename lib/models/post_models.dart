class PostItem {
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;

  PostItem({
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });
}
