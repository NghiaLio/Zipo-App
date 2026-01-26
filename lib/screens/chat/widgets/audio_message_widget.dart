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
    final primaryColor = widget.isMe ? Colors.white : const Color(0xFF0288D1);
    final secondaryColor = widget.isMe ? Colors.white54 : Colors.grey[400];
    final bubbleColor = widget.isMe ? const Color(0xFF0288D1) : Colors.white;

    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.red.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: widget.isMe ? Colors.white : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Lỗi tải âm thanh',
              style: TextStyle(
                color: widget.isMe ? Colors.white : Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Play/Pause Button
              GestureDetector(
                onTap: () {
                  if (_isPlaying) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: primaryColor,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Waveform + Slider Area
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Waveform Background (Bars)
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(20, (index) {
                          // Deterministic heights for waveform look
                          final double height = (index % 5 * 4 + 10).toDouble();
                          final double progress =
                              _duration.inMilliseconds > 0
                                  ? _position.inMilliseconds /
                                      _duration.inMilliseconds
                                  : 0;
                          final bool isPlayed = (index / 20) <= progress;

                          return Container(
                            width: 3,
                            height: height,
                            decoration: BoxDecoration(
                              color:
                                  isPlayed
                                      ? primaryColor
                                      : secondaryColor!.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Invisible Slider for seeking
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 30,
                        thumbShape: SliderComponentShape.noThumb,
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                      ),
                      child: Slider(
                        min: 0,
                        max:
                            _duration.inMilliseconds.toDouble() > 0
                                ? _duration.inMilliseconds.toDouble()
                                : 1,
                        value: _position.inMilliseconds.toDouble().clamp(
                          0,
                          _duration.inMilliseconds.toDouble() > 0
                              ? _duration.inMilliseconds.toDouble()
                              : 1,
                        ),
                        onChanged: (value) async {
                          await _player.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Time Indicators
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: widget.isMe ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: widget.isMe ? Colors.white70 : Colors.black54,
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
