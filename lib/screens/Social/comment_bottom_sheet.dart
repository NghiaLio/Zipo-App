import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintain_chat_app/bloc/post/postBloc.dart';
import 'package:maintain_chat_app/bloc/post/postEvent.dart';
import 'package:maintain_chat_app/bloc/post/postState.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/constants/storagePath.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/services/fileService.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/video_player_widget.dart';
import '../../models/comments_post_models.dart';
import '../../widgets/media_viewer_page.dart';

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
  XFile? _selectedMediaFile;
  String? _selectedMediaType;

  bool isFailLoading = false;
  String? _editingCommentId;
  String? _editingMediaUrl;
  XFile? _editingMediaFile;
  String? _editingMediaType;
  final Map<String, TextEditingController> _editControllers = {};
  final Map<String, FocusNode> _editFocusNodes = {};
  final FileService _fileService = FileService();
  final ImagePicker _imagePicker = ImagePicker();
  VideoPlayerController? _videoPreviewController;
  VideoPlayerController? _editVideoPreviewController;

  @override
  void initState() {
    super.initState();
    // Load comments khi mở bottom sheet
    context.read<PostBloc>().add(LoadCommentForPost(widget.postId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _videoPreviewController?.dispose();
    for (var controller in _editControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _editFocusNodes.values) {
      focusNode.dispose();
    }
    _editVideoPreviewController?.dispose();
    super.dispose();
  }

  void commentPost() async {
    final content = _commentController.text.trim();
    if (content.isEmpty && _selectedMediaFile == null) {
      showSnackBar.show_error('Bạn không thể gửi bình luận trống', context);
      return;
    }
    final currentUser = context.read<UserBloc>().state.userApp;

    // Nếu có media, upload lên storage trước
    String? uploadedMediaUrl;
    if (_selectedMediaFile != null) {
      try {
        final bucketName =
            _selectedMediaType == 'image'
                ? POST_IMAGE_BUCKET
                : POST_VIDEO_BUCKET;
        final folderPath =
            _selectedMediaType == 'image' ? 'comment_images' : 'comment_videos';

        uploadedMediaUrl = await FileService.processFilePicked(
          _selectedMediaFile,
          _selectedMediaType == 'image' ? MessageType.Image : MessageType.Video,
          folderPath,
          _selectedMediaFile!.name,
          bucketName,
        );
      } catch (e) {
        showSnackBar.show_error(
          'Tải lên media thất bại. Vui lòng thử lại.',
          context,
        );
        return;
      }
    }

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.postId,
      userId: currentUser?.id ?? '',
      userName: currentUser?.userName ?? 'Current User',
      userAvatar: currentUser?.avatarUrl ?? 'https://i.pravatar.cc/150?img=3',
      content: content,
      mediaUrl: uploadedMediaUrl,
      mediaType: _selectedMediaType,
      timeAgo: ConvertTime.formatTimestamp(DateTime.now().toUtc()),
    );

    context.read<PostBloc>().add(CommentOnPost(newComment, _replyingToId));

    // Reset input
    _commentController.clear();
    _cancelReply();
  }

  Future<void> _refreshComments() async {
    context.read<PostBloc>().add(LoadCommentForPost(widget.postId));
    // Đợi một chút để state update
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _onReply(String commentId, String userName) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = userName;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    _videoPreviewController?.dispose();
    _videoPreviewController = null;
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
      _selectedMediaFile = null;
      _selectedMediaType = null;
    });
  }

  void _showMediaPicker({bool isEditing = false}) {
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
                      _pickImage(isEditing: isEditing);
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
                      _pickVideo(isEditing: isEditing);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  void _pickImage({bool isEditing = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          if (isEditing) {
            _editingMediaFile = image;
            _editingMediaType = 'image';
            _editingMediaUrl = null;
          } else {
            _selectedMediaFile = image;
            _selectedMediaType = 'image';
          }
        });
      }
    } catch (e) {
      showSnackBar.show_error('Không thể chọn ảnh. Vui lòng thử lại.', context);
    }
  }

  void _pickVideo({bool isEditing = false}) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );
      if (video != null) {
        if (isEditing) {
          _editVideoPreviewController?.dispose();
          _editVideoPreviewController = VideoPlayerController.file(
            File(video.path),
          );
          await _editVideoPreviewController!.initialize();
          setState(() {
            _editingMediaFile = video;
            _editingMediaType = 'video';
            _editingMediaUrl = null;
          });
        } else {
          _videoPreviewController?.dispose();
          _videoPreviewController = VideoPlayerController.file(
            File(video.path),
          );
          await _videoPreviewController!.initialize();
          setState(() {
            _selectedMediaFile = video;
            _selectedMediaType = 'video';
          });
        }
      }
    } catch (e) {
      showSnackBar.show_error(
        'Không thể chọn video. Vui lòng thử lại.',
        context,
      );
    }
  }

  void _removeMedia({bool isEditing = false}) {
    if (isEditing) {
      _editVideoPreviewController?.dispose();
      _editVideoPreviewController = null;
      setState(() {
        _editingMediaFile = null;
        _editingMediaType = null;
        _editingMediaUrl = null;
      });
    } else {
      _videoPreviewController?.dispose();
      _videoPreviewController = null;
      setState(() {
        _selectedMediaFile = null;
        _selectedMediaType = null;
      });
    }
  }

  void _editComment(Comment comment) {
    setState(() {
      _editingCommentId = comment.id;
      _editingMediaUrl = comment.mediaUrl;
      _editingMediaType = comment.mediaType;
      _editingMediaFile = null;

      if (!_editControllers.containsKey(comment.id)) {
        _editControllers[comment.id!] = TextEditingController(
          text: comment.content,
        );
        _editFocusNodes[comment.id!] = FocusNode();
      }
    });
    // Focus vào TextField
    Future.delayed(const Duration(milliseconds: 100), () {
      _editFocusNodes[comment.id]?.requestFocus();
    });
  }

  void _saveEditComment(Comment comment) async {
    final newContent = _editControllers[comment.id]?.text.trim() ?? '';

    // Nếu có media mới, upload lên storage trước
    String? uploadedMediaUrl = _editingMediaUrl;
    String? mediaType = _editingMediaType;

    if (_editingMediaFile != null) {
      try {
        final bucketName =
            _editingMediaType == 'image'
                ? POST_IMAGE_BUCKET
                : POST_VIDEO_BUCKET;
        final folderPath =
            _editingMediaType == 'image' ? 'comment_images' : 'comment_videos';

        uploadedMediaUrl = await FileService.processFilePicked(
          _editingMediaFile,
          _editingMediaType == 'image' ? MessageType.Image : MessageType.Video,
          folderPath,
          _editingMediaFile!.name,
          bucketName,
        );
      } catch (e) {
        showSnackBar.show_error(
          'Tải lên media thất bại. Vui lòng thử lại.',
          context,
        );
        return;
      }
    }

    if (newContent.isNotEmpty) {
      if (newContent != comment.content ||
          uploadedMediaUrl != comment.mediaUrl ||
          mediaType != comment.mediaType) {
        context.read<PostBloc>().add(
          UpdateComment(
            comment.id ?? '',
            widget.postId,
            newContent,
            mediaUrl: uploadedMediaUrl,
            mediaType: mediaType,
          ),
        );
      }
      _cancelEditComment();
    } else {
      showSnackBar.show_error('Bình luận không thể để trống', context);
    }
  }

  void _cancelEditComment() {
    _editVideoPreviewController?.dispose();
    _editVideoPreviewController = null;
    setState(() {
      _editingCommentId = null;
      _editingMediaUrl = null;
      _editingMediaFile = null;
      _editingMediaType = null;
    });
  }

  void _deleteComment(Comment comment) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Xóa bình luận',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bạn có chắc chắn muốn xóa bình luận này?',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Hủy',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.read<PostBloc>().add(
                              DeleteComment(comment.id ?? '', widget.postId),
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Xóa',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showCommentOptions(Comment comment) {
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
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _editComment(comment);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      color: Colors.blue.withOpacity(0.1),
                      child: const Text(
                        'Sửa bình luận',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0288D1),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _deleteComment(comment);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      color: Colors.red.withOpacity(0.1),
                      child: const Text(
                        'Xóa bình luận',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            // Hiển thị lỗi nếu có
            if (state.errorMessage != null && !state.isLoading) {
              log('Error loading comments: ${state.errorMessage}');
              showSnackBar.show_error(state.errorMessage!, context);
              // Nếu không có comments (lỗi load lần đầu) -> hiển thị failure widget
              if (state.commentsOnPost.isEmpty) {
                setState(() {
                  isFailLoading = true;
                });
              }
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final _comments = state.commentsOnPost;
            return isFailLoading
                ? _buildFailureWidget()
                : Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
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
                                'Bình luận (${state.totalCommentOnPost})',
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
                    _comments.isEmpty
                        ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshComments,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: const Center(
                                  child: Text(
                                    'Chưa có bình luận nào. Hãy là người đầu tiên bình luận!',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshComments,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                return _buildCommentCard(_comments[index], 0);
                              },
                            ),
                          ),
                        ),

                    // Input area
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
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
                            if (_selectedMediaFile != null)
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
                                              ? Image.file(
                                                File(_selectedMediaFile!.path),
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )
                                              : _videoPreviewController !=
                                                      null &&
                                                  _videoPreviewController!
                                                      .value
                                                      .isInitialized
                                              ? SizedBox(
                                                width: 200,
                                                height: 150,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio:
                                                          _videoPreviewController!
                                                              .value
                                                              .aspectRatio,
                                                      child: VideoPlayer(
                                                        _videoPreviewController!,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        _videoPreviewController!
                                                                .value
                                                                .isPlaying
                                                            ? Icons
                                                                .pause_circle_filled
                                                            : Icons
                                                                .play_circle_filled,
                                                        size: 56,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _videoPreviewController!
                                                                  .value
                                                                  .isPlaying
                                                              ? _videoPreviewController!
                                                                  .pause()
                                                              : _videoPreviewController!
                                                                  .play();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                              : Container(
                                                width: 200,
                                                height: 150,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                          ),
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
                                    onPressed: commentPost,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
          },
        ),
      ),
    );
  }

  Widget _buildCommentCard(Comment comment, int level) {
    // Tối đa thụt vào 2 lần
    final indent = level > 2 ? 2 : level;
    final leftPadding = 16.0 + (indent * 40.0);
    final currentUser = context.read<UserBloc>().state.userApp;
    final isAuthor = comment.userId == currentUser?.id;

    return Column(
      children: [
        GestureDetector(
          onLongPress: isAuthor ? () => _showCommentOptions(comment) : null,
          child: Padding(
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
                  backgroundImage: CachedNetworkImageProvider(
                    comment.userAvatar,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (isAuthor) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0288D1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Tác giả',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      // N\u1ebfu \u0111ang edit comment n\u00e0y -> hi\u1ec3n th\u1ecb TextField
                      if (_editingCommentId == comment.id) ...[
                        GestureDetector(
                          onTap: () => _showMediaPicker(isEditing: true),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_editingMediaUrl != null ||
                                    _editingMediaFile != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        _editingMediaFile != null
                                            ? (_editingMediaType == 'image'
                                                ? Image.file(
                                                  File(_editingMediaFile!.path),
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                )
                                                : _editVideoPreviewController !=
                                                        null &&
                                                    _editVideoPreviewController!
                                                        .value
                                                        .isInitialized
                                                ? SizedBox(
                                                  width: 200,
                                                  height: 150,
                                                  child: AspectRatio(
                                                    aspectRatio:
                                                        _editVideoPreviewController!
                                                            .value
                                                            .aspectRatio,
                                                    child: VideoPlayer(
                                                      _editVideoPreviewController!,
                                                    ),
                                                  ),
                                                )
                                                : Container(
                                                  width: 200,
                                                  height: 150,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ))
                                            : (_editingMediaType == 'image'
                                                ? CachedNetworkImage(
                                                  imageUrl: _editingMediaUrl!,
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                )
                                                : VideoPlayerWidget(
                                                  videoUrl: _editingMediaUrl!,
                                                  width: 200,
                                                  height: 150,
                                                )),
                                  ),
                                  // Overlay indicators
                                  Container(
                                    width:
                                        _editingMediaType == 'image'
                                            ? 150
                                            : 200,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white70,
                                      size: 30,
                                    ),
                                  ),
                                  // Close button
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap:
                                          () => _removeMedia(isEditing: true),
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
                                ] else ...[
                                  // Placeholder when no media
                                  Container(
                                    width: 150,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.grey[400],
                                          size: 32,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Thêm ảnh/video',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF0288D1),
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: _editControllers[comment.id],
                            focusNode: _editFocusNodes[comment.id],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nội dung bình luận ...',
                              contentPadding: EdgeInsets.all(2),
                            ),
                            style: const TextStyle(fontSize: 14),
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: _cancelEditComment,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'H\u1ee7y',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _saveEditComment(comment),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0288D1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'L\u01b0u',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Hi\u1ec3n th\u1ecb text b\u00ecnh th\u01b0\u1eddng
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            comment.content,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                      if (comment.mediaUrl != null &&
                          comment.mediaType == 'image' &&
                          _editingCommentId != comment.id)
                        const SizedBox(height: 8),
                      if (comment.mediaUrl != null &&
                          comment.mediaType == 'image' &&
                          _editingCommentId != comment.id)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MediaViewerPage(
                                      url: comment.mediaUrl!,
                                      mediaType: 'image',
                                      userName: comment.userName,
                                      userAvatar: comment.userAvatar,
                                    ),
                              ),
                            );
                          },
                          child: ClipRRect(
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
                        ),
                      if (comment.mediaUrl != null &&
                          comment.mediaType == 'video' &&
                          _editingCommentId != comment.id)
                        const SizedBox(height: 8),
                      if (comment.mediaUrl != null &&
                          comment.mediaType == 'video' &&
                          _editingCommentId != comment.id)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: VideoPlayerWidget(
                            videoUrl: comment.mediaUrl!,
                            width: 250,
                            height: 180,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MediaViewerPage(
                                        url: comment.mediaUrl!,
                                        mediaType: 'video',
                                        userName: comment.userName,
                                        userAvatar: comment.userAvatar,
                                      ),
                                ),
                              );
                            },
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
                            onTap:
                                () => _onReply(
                                  comment.id ?? '',
                                  comment.userName,
                                ),
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
        ),
        // Replies
        if (comment.replies.isNotEmpty)
          ...comment.replies.map(
            (reply) => _buildCommentCard(reply, level + 1),
          ),
      ],
    );
  }

  Widget _buildFailureWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 8),
          const Text(
            'Không thể tải bình luận.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFailLoading = false;
              });
              // Trigger reload comments
              context.read<PostBloc>().add(LoadCommentForPost(widget.postId));
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
