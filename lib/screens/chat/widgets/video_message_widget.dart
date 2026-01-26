import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessageWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onTap;

  const VideoMessageWidget({super.key, required this.videoUrl, this.onTap});

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl.trim()),
    );

    _controller
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {
              _initialized = true;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
        });

    _controller.addListener(() {
      if (_controller.value.hasError && mounted) {
        setState(() {
          _hasError = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.onTap ??
          () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
                _isPlaying = false;
              } else {
                _controller.play();
                _isPlaying = true;
              }
            });
          },
      child: Container(
        color: Colors.black,
        width: 250,
        height: 250 * (9 / 16),
        child:
            _hasError
                ? Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                )
                : _initialized
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    if (!_isPlaying)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                  ],
                )
                : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
      ),
    );
  }
}
