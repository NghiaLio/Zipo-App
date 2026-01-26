import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maintain_chat_app/screens/Social/comment_bottom_sheet.dart';
import '../../models/post_models.dart';
import 'create_post_page.dart';
import '../../widgets/video_player_widget.dart';
import '../../widgets/media_viewer_page.dart';

class PostCard extends StatelessWidget {
  final PostItem post;
  final String? currentUserId;
  final VoidCallback? onDelete;
  final Function(String, bool)? onToggleLike;

  const PostCard({
    super.key,
    required this.post,
    this.currentUserId,
    this.onDelete,
    this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      post.authorAvatar.isNotEmpty
                          ? CachedNetworkImageProvider(post.authorAvatar)
                          : null,
                  child:
                      post.authorAvatar.isEmpty
                          ? const Icon(Icons.person, size: 20)
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (currentUserId != null && post.authorId == currentUserId)
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () => _showOptionsBottomSheet(context),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(post.content, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          if (post.imageUrl.isNotEmpty)
            post.imageUrl.contains('.mp4') || post.imageUrl.contains('video')
                ? VideoPlayerWidget(
                  videoUrl: post.imageUrl,
                  width: double.infinity,
                  height: 300,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MediaViewerPage(
                              url: post.imageUrl,
                              mediaType: 'video',
                              userName: post.authorName,
                              userAvatar: post.authorAvatar,
                            ),
                      ),
                    );
                  },
                )
                : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MediaViewerPage(
                              url: post.imageUrl,
                              mediaType: 'image',
                              userName: post.authorName,
                              userAvatar: post.authorAvatar,
                            ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildActionButton(
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(post.isLiked),
                      size: 22,
                      color: post.isLiked ? Colors.red : null,
                    ),
                  ),
                  post.likes.toString(),
                  () {
                    if (onToggleLike != null) {
                      onToggleLike!(post.id ?? '', !post.isLiked);
                    }
                  },
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  Icon(Icons.comment_outlined),
                  post.comments.toString(),
                  () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) => CommentBottomSheet(
                            postId: post.id ?? '',
                            commentCount: post.comments,
                          ),
                    );
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Widget icon, String count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(count, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nút chỉnh sửa bài viết
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CreatePostPage(postToEdit: post),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.black),
                          const SizedBox(width: 16),
                          Text(
                            'Chỉnh sửa bài viết',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Nút xóa bài viết
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDelete(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red[700]),
                          const SizedBox(width: 16),
                          Text(
                            'Xóa bài viết',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Nút Cancel
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.close, color: Colors.grey[700]),
                          const SizedBox(width: 16),
                          Text(
                            'Hủy',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa bài viết này không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onDelete != null) {
                    onDelete!();
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }
}
