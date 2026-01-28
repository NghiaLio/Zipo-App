import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_hasError) {
      return Container(
        width: widget.width,
        height: widget.height ?? 200,
        decoration: BoxDecoration(
          color: theme.disabledColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 40, color: theme.disabledColor),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.could_not_load_video,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        width: widget.width,
        height: widget.height ?? 200,
        decoration: BoxDecoration(
          color: theme.disabledColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap:
          widget.onTap ??
          () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (!_controller.value.isPlaying)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            // Progress indicator
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: colorScheme.primary,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
