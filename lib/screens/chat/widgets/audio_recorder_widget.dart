import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String audioPath) onSend;
  final VoidCallback onCancel;

  const AudioRecorderWidget({
    super.key,
    required this.onSend,
    required this.onCancel,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = true;
  bool _isPlaying = false;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  Duration _playDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndStartRecording();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _playDuration = position;
        });
      }
    });
  }

  Future<void> _requestPermissionAndStartRecording() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();

      if (status.isGranted) {
        await _startRecording();
      } else if (status.isDenied) {
        debugPrint('Microphone permission denied');
        if (mounted) {
          widget.onCancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.mic_permission_needed,
              ),
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        debugPrint('Microphone permission permanently denied');
        if (mounted) {
          widget.onCancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.mic_permission_settings,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      if (mounted) {
        widget.onCancel();
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Lấy thư mục tạm để lưu file
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        debugPrint('Recording to: $path');

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        // Bắt đầu đếm thời gian
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordDuration = Duration(seconds: timer.tick);
            });
          }
        });

        debugPrint('Recording started successfully');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      if (mounted) {
        widget.onCancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.start_recording_error}: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();

      debugPrint('Recording stopped. Path: $path');

      if (mounted && path != null) {
        setState(() {
          _isRecording = false;
          _audioPath = path;
          _totalDuration = _recordDuration;
        });
      } else if (mounted) {
        widget.onCancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.stop_recording_error),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      if (mounted) {
        widget.onCancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.stop_recording_error}: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_audioPath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(_audioPath!));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child:
            _isRecording
                ? _buildRecordingUI(theme, colorScheme)
                : _buildPreviewUI(theme, colorScheme),
      ),
    );
  }

  Widget _buildRecordingUI(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        // Mic button (đang ghi - màu đỏ)
        GestureDetector(
          onTap: _stopRecording,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.error.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.stop_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Thời gian ghi âm
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.recording_status,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDuration(_recordDuration),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewUI(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slider và Play/Pause
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                color: colorScheme.primary,
                size: 40,
              ),
              onPressed: _togglePlayPause,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderTheme(
                    data: theme.sliderTheme.copyWith(
                      activeTrackColor: colorScheme.primary,
                      inactiveTrackColor: colorScheme.primary.withOpacity(0.1),
                      thumbColor: colorScheme.primary,
                      overlayColor: colorScheme.primary.withOpacity(0.1),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _playDuration.inSeconds.toDouble(),
                      max:
                          _totalDuration.inSeconds.toDouble() > 0
                              ? _totalDuration.inSeconds.toDouble()
                              : 1,
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await _audioPlayer.seek(position);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_playDuration),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                        Text(
                          _formatDuration(_totalDuration),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.disabledColor,
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
        const SizedBox(height: 16),
        // Nút Hủy và Gửi
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _audioPlayer.stop();
                  widget.onCancel();
                },
                icon: Icon(Icons.close_rounded, color: colorScheme.error),
                label: Text(AppLocalizations.of(context)!.cancel_action),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  side: BorderSide(color: colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_audioPath != null) {
                    _audioPlayer.stop();
                    widget.onSend(_audioPath!);
                  }
                },
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                label: Text(AppLocalizations.of(context)!.save_button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
