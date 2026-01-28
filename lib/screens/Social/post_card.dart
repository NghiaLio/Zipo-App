import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                  backgroundImage:
                      post.authorAvatar.isNotEmpty
                          ? CachedNetworkImageProvider(post.authorAvatar)
                          : null,
                  child:
                      post.authorAvatar.isEmpty
                          ? Icon(
                            Icons.person,
                            size: 20,
                            color: theme.disabledColor,
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentUserId != null && post.authorId == currentUserId)
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
                    onPressed: () => _showOptionsBottomSheet(context),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              post.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
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
                          color: colorScheme.onSurface.withOpacity(0.05),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: double.infinity,
                          height: 300,
                          color: colorScheme.onSurface.withOpacity(0.05),
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: theme.disabledColor,
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
                  context,
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(post.isLiked),
                      size: 22,
                      color:
                          post.isLiked
                              ? Colors.red
                              : colorScheme.onSurface.withOpacity(0.6),
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
                  context,
                  Icon(
                    Icons.comment_outlined,
                    size: 22,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
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
                  icon: Icon(
                    Icons.share_outlined,
                    size: 22,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    Widget icon,
    String count,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              count,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
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
                      color: theme.disabledColor.withOpacity(0.3),
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
                          Icon(
                            Icons.edit_outlined,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!.edit_post_title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
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
                          Icon(Icons.delete_outline, color: colorScheme.error),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!.delete_post_action,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
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
                          Icon(Icons.close, color: theme.disabledColor),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!.cancel_action,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.disabledColor,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              AppLocalizations.of(context)!.confirm_delete_title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              AppLocalizations.of(context)!.confirm_delete_post_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.cancel_action,
                  style: TextStyle(color: theme.disabledColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onDelete != null) {
                    onDelete!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.delete_action),
              ),
            ],
          ),
    );
  }
}
