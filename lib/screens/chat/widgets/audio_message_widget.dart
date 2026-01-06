import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const AudioMessageWidget({
    super.key,
    required this.audioUrl,
    required this.isMe,
  });

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      debugPrint('Loading audio from URL: ${widget.audioUrl}');
      var duration = await _player.setUrl(widget.audioUrl.trim());
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
      debugPrint('Audio loaded successfully. Duration: $duration');
    } catch (e) {
      debugPrint("Error loading audio: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }

    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _player.seek(Duration.zero);
            _player.pause();
          }
        });
      }
    });

    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() => _position = pos);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.toString().padLeft(2, '0');
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.red.shade100 : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: widget.isMe ? Colors.red.shade700 : Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Không thể tải audio',
                style: TextStyle(
                  color: widget.isMe ? Colors.red.shade700 : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      color: widget.isMe ? Colors.blueAccent : Colors.grey[200],
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.isMe ? Colors.white : Colors.black,
            ),
            onPressed: () {
              if (_isPlaying) {
                _player.pause();
              } else {
                _player.play();
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 2,
                    thumbColor: widget.isMe ? Colors.white : Colors.blueAccent,
                    activeTrackColor:
                        widget.isMe ? Colors.white70 : Colors.blueAccent,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble().clamp(
                      0,
                      _duration.inSeconds.toDouble(),
                    ),
                    onChanged: (value) async {
                      await _player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isMe ? Colors.white70 : Colors.black54,
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
    );
  }
}
