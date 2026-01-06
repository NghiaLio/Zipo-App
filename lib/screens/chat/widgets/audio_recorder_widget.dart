import 'dart:async';
import 'package:flutter/material.dart';
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
            const SnackBar(
              content: Text('Cần quyền truy cập microphone để ghi âm'),
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        debugPrint('Microphone permission permanently denied');
        if (mounted) {
          widget.onCancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng cấp quyền microphone trong Settings'),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi bắt đầu ghi âm: $e')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Lỗi khi dừng ghi âm')));
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      if (mounted) {
        widget.onCancel();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi dừng ghi âm: $e')));
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _isRecording ? _buildRecordingUI() : _buildPreviewUI(),
      ),
    );
  }

  Widget _buildRecordingUI() {
    return Row(
      children: [
        // Mic button (đang ghi - màu đỏ)
        GestureDetector(
          onTap: _stopRecording,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(width: 16),
        // Thời gian ghi âm
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đang ghi âm...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slider và Play/Pause
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.blueAccent,
              ),
              onPressed: _togglePlayPause,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: _playDuration.inSeconds.toDouble(),
                    max: _totalDuration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_playDuration),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          _formatDuration(_totalDuration),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Nút Hủy và Gửi
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _audioPlayer.stop();
                  widget.onCancel();
                },
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text('Hủy', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Gửi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
