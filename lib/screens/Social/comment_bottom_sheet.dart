import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/video_player_widget.dart';

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? mediaUrl;
  final String? mediaType; // 'image' or 'video'
  final String timeAgo;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    required this.timeAgo,
    this.replies = const [],
  });
}

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final int commentCount;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.commentCount,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _replyingToId;
  String? _replyingToName;
  String? _selectedMediaUrl;
  String? _selectedMediaType;

  // Fake data
  final List<Comment> _comments = [
    Comment(
      id: '1',
      userId: 'user1',
      userName: 'Nguyễn Văn A',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: 'Bài viết hay quá! Mình rất thích 👍',
      timeAgo: '2 giờ trước',
      replies: [
        Comment(
          id: '1-1',
          userId: 'user2',
          userName: 'Trần Thị B',
          userAvatar: 'https://i.pravatar.cc/150?img=2',
          content: 'Mình cũng nghĩ vậy!',
          mediaUrl: 'https://picsum.photos/400/300?random=1',
          mediaType: 'image',
          timeAgo: '1 giờ trước',
          replies: [
            Comment(
              id: '1-1-1',
              userId: 'user3',
              userName: 'Lê Văn C',
              userAvatar: 'https://i.pravatar.cc/150?img=3',
              content: 'Đồng ý với bạn 😊',
              timeAgo: '30 phút trước',
            ),
          ],
        ),
        Comment(
          id: '1-2',
          userId: 'user4',
          userName: 'Phạm Thị D',
          userAvatar: 'https://i.pravatar.cc/150?img=4',
          content: 'Cảm ơn bạn đã chia sẻ!',
          timeAgo: '45 phút trước',
        ),
      ],
    ),
    Comment(
      id: '2',
      userId: 'user5',
      userName: 'Hoàng Văn E',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Thật tuyệt vời! Bạn có thể chia sẻ thêm không? 🤔',
      mediaUrl: 'https://picsum.photos/400/300?random=2',
      mediaType: 'image',
      timeAgo: '3 giờ trước',
    ),
    Comment(
      id: '3',
      userId: 'user6',
      userName: 'Đặng Thị F',
      userAvatar: 'https://i.pravatar.cc/150?img=6',
      content: 'Rất bổ ích, cảm ơn bạn!',
      timeAgo: '5 giờ trước',
    ),
    Comment(
      id: '4',
      userId: 'user7',
      userName: 'Võ Văn G',
      userAvatar: 'https://i.pravatar.cc/150?img=7',
      content: 'Video này hay quá! 🎥',
      mediaUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      mediaType: 'video',
      timeAgo: '6 giờ trước',
    ),
    Comment(
      id: '5',
      userId: 'user8',
      userName: 'Phan Thị H',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      content: 'Clip này quá đẹp! 😍',
      mediaUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      mediaType: 'video',
      timeAgo: '7 giờ trước',
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onReply(String commentId, String userName) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = userName;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
      _selectedMediaUrl = null;
      _selectedMediaType = null;
    });
  }

  void _showMediaPicker() {
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
                  ListTile(
                    leading: const Icon(Icons.image, color: Color(0xFF0288D1)),
                    title: const Text('Chọn ảnh'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.videocam,
                      color: Color(0xFF0288D1),
                    ),
                    title: const Text('Chọn video'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickVideo();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  void _pickImage() {
    // TODO: Implement image picker
    setState(() {
      _selectedMediaUrl = 'https://picsum.photos/400/300?random=10';
      _selectedMediaType = 'image';
    });
  }

  void _pickVideo() {
    // TODO: Implement video picker
    setState(() {
      _selectedMediaUrl =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      _selectedMediaType = 'video';
    });
  }

  void _removeMedia() {
    setState(() {
      _selectedMediaUrl = null;
      _selectedMediaType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bình luận (${_comments.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Comments list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return _buildCommentCard(_comments[index], 0);
                },
              ),
            ),

            // Input area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_replyingToName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: Colors.grey[100],
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Đang phản hồi $_replyingToName',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: _cancelReply,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedMediaUrl != null)
                      Container(
                        margin: const EdgeInsets.only(
                          left: 50,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  _selectedMediaType == 'image'
                                      ? CachedNetworkImage(
                                        imageUrl: _selectedMediaUrl!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                      : VideoPlayerWidget(
                                        videoUrl: _selectedMediaUrl!,
                                        width: 120,
                                        height: 120,
                                      ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: _removeMedia,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey[700],
                              ),
                              onPressed: _showMediaPicker,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: _commentController,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Viết bình luận...',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                ),
                                maxLines: null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color:
                                  _commentController.text.isEmpty
                                      ? Colors.grey
                                      : const Color(0xFF0288D1),
                            ),
                            onPressed: () {
                              // TODO: Send comment
                              if (_commentController.text.isNotEmpty) {
                                print('Send: ${_commentController.text}');
                                _commentController.clear();
                                _cancelReply();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(Comment comment, int level) {
    // Tối đa thụt vào 2 lần
    final indent = level > 2 ? 2 : level;
    final leftPadding = 16.0 + (indent * 40.0);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: leftPadding,
            right: 16,
            top: 12,
            bottom: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: indent > 0 ? 16 : 18,
                backgroundImage: CachedNetworkImageProvider(comment.userAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (comment.mediaUrl != null &&
                        comment.mediaType == 'image')
                      const SizedBox(height: 8),
                    if (comment.mediaUrl != null &&
                        comment.mediaType == 'image')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: comment.mediaUrl!,
                          width: 200,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                width: 200,
                                height: 150,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                width: 200,
                                height: 150,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image),
                                ),
                              ),
                        ),
                      ),
                    if (comment.mediaUrl != null &&
                        comment.mediaType == 'video')
                      const SizedBox(height: 8),
                    if (comment.mediaUrl != null &&
                        comment.mediaType == 'video')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: VideoPlayerWidget(
                          videoUrl: comment.mediaUrl!,
                          width: 250,
                          height: 180,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          comment.timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _onReply(comment.id, comment.userName),
                          child: Text(
                            'Phản hồi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Replies
        if (comment.replies.isNotEmpty)
          ...comment.replies.map(
            (reply) => _buildCommentCard(reply, level + 1),
          ),
      ],
    );
  }
}
