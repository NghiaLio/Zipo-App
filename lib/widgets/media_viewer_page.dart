import 'dart:io';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';

class MediaViewerPage extends StatefulWidget {
  final String url;
  final String mediaType; // 'image' or 'video'
  final String userName;
  final String userAvatar;

  const MediaViewerPage({
    super.key,
    required this.url,
    required this.mediaType,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  VideoPlayerController? _videoController;
  bool _showControls = true;
  bool _isDownloading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') {
      _initializeVideo();
    }
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();

      _videoController!.addListener(() {
        if (_videoController!.value.hasError && mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _downloadMedia() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      // Check permissions
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          // If storage permission is not enough (Android 13+), check photos/videos
          status = await Permission.photos.request();
          if (!status.isGranted) {
            showSnackBar.show_error(
              AppLocalizations.of(context)!.storage_permission_denied,
              context,
            );
            setState(() => _isDownloading = false);
            return;
          }
        }
      }

      final dio = Dio();
      final dir = await getTemporaryDirectory();
      final fileName = widget.url.split('/').last.split('?').first;
      final savePath = '${dir.path}/$fileName';

      await dio.download(widget.url, savePath);

      // In real scenario, you might want to move this to a more permanent gallery location
      // Using gallery_saver or similar. For now, we save to temp and notify.
      showSnackBar.show_success(
        AppLocalizations.of(context)!.download_success_message(fileName),
        context,
      );
    } catch (e) {
      showSnackBar.show_error(
        AppLocalizations.of(context)!.download_error_message(e.toString()),
        context,
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Content
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              child:
                  widget.mediaType == 'image'
                      ? InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.url,
                          placeholder:
                              (context, url) => CircularProgressIndicator(
                                color: colorScheme.primary,
                                strokeWidth: 2,
                              ),
                          errorWidget:
                              (context, url, error) => const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                                size: 50,
                              ),
                          fit: BoxFit.contain,
                        ),
                      )
                      : _hasError
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white54,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.could_not_load_video,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _hasError = false;
                              });
                              _initializeVideo();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary.withOpacity(
                                0.3,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(
                                color: colorScheme.primary,
                                width: 1,
                              ),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: Text(
                              AppLocalizations.of(context)!.retry_button,
                            ),
                          ),
                        ],
                      )
                      : _videoController != null &&
                          _videoController!.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                      : CircularProgressIndicator(
                        color: colorScheme.primary,
                        strokeWidth: 2,
                      ),
            ),
          ),

          // Top Bar (User Info + Close)
          if (_showControls)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 20,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white10,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.userAvatar,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.just_now_label,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon:
                          _isDownloading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                              : const Icon(Icons.download, color: Colors.white),
                      onPressed: _isDownloading ? null : _downloadMedia,
                    ),
                  ],
                ),
              ),
            ),

          // Video Controls
          if (widget.mediaType == 'video' &&
              _videoController != null &&
              _videoController!.value.isInitialized &&
              _showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: colorScheme.primary,
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _videoController!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                            size: 50,
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
