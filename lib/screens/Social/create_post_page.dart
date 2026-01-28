// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintain_chat_app/bloc/post/postBloc.dart';
import 'package:maintain_chat_app/bloc/post/postEvent.dart';
import 'package:maintain_chat_app/constants/storagePath.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/services/fileService.dart';
import 'package:maintain_chat_app/utils/convert_time.dart';
import 'package:video_player/video_player.dart';
import '../../bloc/users/userBloc.dart';
import '../../bloc/users/userState.dart';
import '../../models/post_models.dart';
import '../../widgets/video_player_widget.dart';
import '../../widgets/TopSnackBar.dart';

class CreatePostPage extends StatefulWidget {
  final PostItem? postToEdit;
  final bool isEditMode;

  const CreatePostPage({super.key, this.postToEdit})
    : isEditMode = postToEdit != null;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // For new posts - use File
  File? _selectedMediaFile;
  String? _selectedMediaType;

  // For edit mode - use URL
  String? _editMediaUrl;

  bool _isPosting = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    // Pre-fill data nếu đang edit
    if (widget.isEditMode && widget.postToEdit != null) {
      _contentController.text = widget.postToEdit!.content;
      _editMediaUrl =
          widget.postToEdit!.imageUrl.isNotEmpty
              ? widget.postToEdit!.imageUrl
              : null;
      if (_editMediaUrl != null) {
        // Detect media type
        if (_editMediaUrl!.contains('.mp4') ||
            _editMediaUrl!.contains('video')) {
          _selectedMediaType = 'video';
        } else {
          _selectedMediaType = 'image';
        }
      }
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedMediaFile = File(image.path);
          _selectedMediaType = 'image';
          _editMediaUrl = null; // Clear edit URL when selecting new media
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar.show_error(
          AppLocalizations.of(context)!.select_image_error,
          context,
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        // Dispose old video controller if exists
        _videoController?.dispose();

        final videoFile = File(video.path);
        final controller = VideoPlayerController.file(videoFile);

        await controller.initialize();

        setState(() {
          _selectedMediaFile = videoFile;
          _selectedMediaType = 'video';
          _videoController = controller;
          _editMediaUrl = null; // Clear edit URL when selecting new media
        });
      }
    } catch (e) {
      if (mounted) {
        showSnackBar.show_error(
          AppLocalizations.of(context)!.select_video_error,
          context,
        );
      }
    }
  }

  void _removeMedia() {
    _videoController?.dispose();
    setState(() {
      _selectedMediaFile = null;
      _editMediaUrl = null;
      _selectedMediaType = null;
      _videoController = null;
    });
  }

  void _createPost() async {
    if (_contentController.text.trim().isEmpty) {
      showSnackBar.show_error(
        AppLocalizations.of(context)!.enter_post_content_error,
        context,
      );
      return;
    }
    try {
      setState(() {
        _isPosting = true;
      });

      String mediaUrl =
          _editMediaUrl ?? ''; // Keep existing media URL if not changed
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Only upload new media if user selected a new file
      if (_selectedMediaFile != null) {
        if (_selectedMediaType == 'image') {
          //upload image and get url
          mediaUrl = await FileService.processFilePicked(
            XFile(_selectedMediaFile!.path),
            MessageType.Image,
            timestamp,
            '$timestamp.jpg',
            POST_IMAGE_BUCKET,
          );
        } else if (_selectedMediaType == 'video') {
          //upload video and get url
          mediaUrl = await FileService.processFilePicked(
            XFile(_selectedMediaFile!.path),
            MessageType.Video,
            timestamp,
            '$timestamp.mp4',
            POST_VIDEO_BUCKET,
          );
        }
      }

      final UserApp? currentUser = context.read<UserBloc>().state.userApp;

      if (widget.isEditMode && widget.postToEdit != null) {
        // Edit existing post
        context.read<PostBloc>().add(
          UpdatePost(
            widget.postToEdit!.id!,
            _contentController.text.trim(),
            mediaUrl,
          ),
        );
        Navigator.pop(context, widget.postToEdit);
        showSnackBar.show_success(
          AppLocalizations.of(context)!.post_updated_message,
          context,
        );
      } else {
        // Create new post
        // Generate clientId (unique identifier for this post from client)
        final String clientId =
            '${currentUser?.id ?? ''}_${DateTime.now().millisecondsSinceEpoch}';

        final now = DateTime.now().toUtc();
        PostItem newPost = PostItem(
          clientId: clientId,
          content: _contentController.text.trim(),
          imageUrl: mediaUrl,
          authorId: currentUser?.id ?? '',
          authorName: currentUser?.userName ?? '',
          authorAvatar: currentUser?.avatarUrl ?? '',
          timeAgo: ConvertTime.formatTimestamp(now),
          createdAt: now,
          likes: 0,
          comments: 0,
        );

        context.read<PostBloc>().add(CreatePost(newPost));
        Navigator.pop(context, newPost);
      }
    } catch (e) {
      showSnackBar.show_error(
        widget.isEditMode
            ? AppLocalizations.of(context)!.update_post_error
            : AppLocalizations.of(context)!.create_post_error,
        context,
      );
      Navigator.pop(context, 404);
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Widget _buildMediaPreview() {
    // Preview from File (new post)
    if (_selectedMediaFile != null) {
      if (_selectedMediaType == 'image') {
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: Image.file(_selectedMediaFile!, fit: BoxFit.cover),
        );
      } else if (_selectedMediaType == 'video' && _videoController != null) {
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: SizedBox(
            height: 240,
            child:
                _videoController!.value.isInitialized
                    ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          IconButton(
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              size: 64,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _videoController!.value.isPlaying
                                    ? _videoController!.pause()
                                    : _videoController!.play();
                              });
                            },
                          ),
                        ],
                      ),
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
        );
      }
    }

    // Preview from URL (edit mode)
    if (_editMediaUrl != null) {
      if (_selectedMediaType == 'image') {
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: CachedNetworkImage(
            imageUrl: _editMediaUrl!,
            fit: BoxFit.cover,
          ),
        );
      } else if (_selectedMediaType == 'video') {
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: VideoPlayerWidget(
            videoUrl: _editMediaUrl!,
            width: double.infinity,
            height: 240,
          ),
        );
      }
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final currentUser = userState.userApp;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.isEditMode
                  ? AppLocalizations.of(context)!.edit_post_title
                  : AppLocalizations.of(context)!.create_post_title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: _isPosting ? null : _createPost,
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    disabledForegroundColor: theme.disabledColor,
                  ),
                  child:
                      _isPosting
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                          : Text(
                            widget.isEditMode
                                ? AppLocalizations.of(context)!.save_action
                                : AppLocalizations.of(context)!.post_action,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // User info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                        backgroundImage:
                            currentUser?.avatarUrl != null &&
                                    currentUser!.avatarUrl!.isNotEmpty
                                ? CachedNetworkImageProvider(
                                  currentUser.avatarUrl!,
                                )
                                : null,
                        child:
                            currentUser?.avatarUrl == null ||
                                    currentUser!.avatarUrl!.isEmpty
                                ? Icon(
                                  Icons.person,
                                  size: 28,
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
                              currentUser?.userName ?? 'User',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.public,
                                    size: 14,
                                    color: colorScheme.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.public_visibility,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.post_hint,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: theme.disabledColor,
                      ),
                      border: InputBorder.none,
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // Media preview
                if (_selectedMediaFile != null || _editMediaUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildMediaPreview(),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _removeMedia,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Add to post options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: colorScheme.onSurface.withOpacity(0.02),
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.add_to_post,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.image,
                            color: Colors.green,
                            size: 28,
                          ),
                          onPressed: _pickImage,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.videocam,
                            color: Colors.red,
                            size: 28,
                          ),
                          onPressed: _pickVideo,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: Colors.orange[700],
                            size: 28,
                          ),
                          onPressed: () {
                            // TODO: Add emoji picker
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
