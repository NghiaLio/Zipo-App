// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/bloc/messages/messageState.dart';
import 'package:maintain_chat_app/constants/storagePath.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/services/fileService.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';
import '../../models/userModels.dart';
import '../profiles/profile_detail_page.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';
import 'widgets/audio_recorder_widget.dart';

// ================== 2. MAIN SCREEN ==================

class ModernChatScreen extends StatefulWidget {
  final UserApp user;
  final String chatId;

  const ModernChatScreen({super.key, required this.user, required this.chatId});

  @override
  State<ModernChatScreen> createState() => _ModernChatScreenState();
}

class _ModernChatScreenState extends State<ModernChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isUploadingImage = false;
  bool _isUploadingVideo = false;
  bool _isRecordingAudio = false;
  bool _isUploadingAudio = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Khởi tạo MessageService và load messages
    final messageBloc = context.read<MessageBloc>();
    messageBloc.messageRepository.init(widget.chatId, widget.user.id);
    messageBloc.add(LoadMessagesEvent(widget.chatId));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && mounted) {
      _scrollController.jumpTo(0); // Jump ngay lập tức không có animation
    }
  }

  void sendMessageText() async {
    setState(() {});
    final content = _textController.text.trim();
    final MessageItem newMessage = MessageItem(
      senderID: _firebaseAuth.currentUser?.uid ?? '',
      content: content,
      type: MessageType.Text,
      sendAt: Timestamp.fromDate(DateTime.now()),
      isSeen: false,
      isLatest: true,
    );
    if (content.isNotEmpty) {
      final messageBloc = context.read<MessageBloc>();
      messageBloc.add(CreateMessageEvent(newMessage, widget.chatId));
      _textController.clear();
    }
  }

  void sendMessageImage() async {
    Navigator.pop(context);
    setState(() {
      _isUploadingImage = true;
    });

    try {
      final fileUrl = await FileService().pickImage(
        '$MESSAGE_IMAGE_PATH/${widget.chatId}',
        MESSAGE_IMAGE_BUCKET,
      );
      if (fileUrl != null) {
        final MessageItem newMessage = MessageItem(
          senderID: _firebaseAuth.currentUser?.uid ?? '',
          content: fileUrl,
          type: MessageType.Image,
          sendAt: Timestamp.fromDate(DateTime.now()),
          isSeen: false,
          isLatest: true,
        );
        final messageBloc = context.read<MessageBloc>();
        messageBloc.add(CreateMessageEvent(newMessage, widget.chatId));
      }
    } catch (e) {
      showSnackBar.show_error('Gửi ảnh thất bại: $e', context);
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  void sendMessageVideo() async {
    Navigator.pop(context);
    setState(() {
      _isUploadingVideo = true;
    });

    try {
      final fileUrl = await FileService().pickVideo(
        '$MESSAGE_VIDEO_PATH/${widget.chatId}',
        MESSAGE_VIDEO_BUCKET,
      );
      if (fileUrl != null) {
        final MessageItem newMessage = MessageItem(
          senderID: _firebaseAuth.currentUser?.uid ?? '',
          content: fileUrl,
          type: MessageType.Video,
          sendAt: Timestamp.fromDate(DateTime.now()),
          isSeen: false,
          isLatest: true,
        );
        final messageBloc = context.read<MessageBloc>();
        messageBloc.add(CreateMessageEvent(newMessage, widget.chatId));
      }
    } catch (e) {
      showSnackBar.show_error('Gửi video thất bại: $e', context);
    } finally {
      setState(() {
        _isUploadingVideo = false;
      });
    }
  }

  Widget _buildUploadingPlaceholder(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.blueAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
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
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                  title: const Text('Chọn ảnh'),
                  onTap: sendMessageImage,
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.videocam, color: Colors.white),
                  ),
                  title: const Text('Chọn video'),
                  onTap: sendMessageVideo,
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                  title: const Text('Ghi âm'),
                  onTap: _startAudioRecording,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startAudioRecording() {
    Navigator.pop(context); // Đóng menu
    setState(() {
      _isRecordingAudio = true;
    });
  }

  void _cancelAudioRecording() {
    setState(() {
      _isRecordingAudio = false;
    });
  }

  Future<void> _sendAudioMessage(String audioPath) async {
    setState(() {
      _isRecordingAudio = false;
      _isUploadingAudio = true;
    });

    try {
      // Upload audio file và lấy URL
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final audioUrl = await FileService().uploadAudioFile(
        File(audioPath),
        '$MESSAGE_AUDIO_PATH/${widget.chatId}',
        fileName,
        MESSAGE_AUDIO_BUCKET,
      );

      if (audioUrl == null) {
        throw Exception('Upload failed');
      }

      final MessageItem newMessage = MessageItem(
        senderID: _firebaseAuth.currentUser?.uid ?? '',
        content: audioUrl,
        type: MessageType.Audio,
        sendAt: Timestamp.fromDate(DateTime.now()),
        isSeen: false,
        isLatest: true,
      );

      final messageBloc = context.read<MessageBloc>();
      messageBloc.add(CreateMessageEvent(newMessage, widget.chatId));

      // Xóa file local sau khi gửi thành công
      try {
        final file = File(audioPath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Deleted local audio file: $audioPath');
        }
      } catch (e) {
        debugPrint('Error deleting local file: $e');
      }
    } catch (e) {
      showSnackBar.show_error('Gửi audio thất bại: $e', context);
    } finally {
      setState(() {
        _isUploadingAudio = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            await context.read<MessageBloc>().messageRepository.dispose();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  widget.user.avatarUrl?.isNotEmpty ?? false
                      ? CachedNetworkImageProvider(widget.user.avatarUrl!)
                      : null,
              child:
                  widget.user.avatarUrl?.isEmpty ?? true
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.userName,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  widget.user.isOnline ?? false ? "Đang hoạt động" : "Offline",
                  style: TextStyle(
                    color:
                        widget.user.isOnline ?? false
                            ? Colors.green
                            : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'view_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfileDetailPage(
                          user: widget.user,
                          isViewOnly: true,
                        ),
                  ),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'view_profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('Xem trang cá nhân'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: BlocListener<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state.sendState == false) {
            showSnackBar.show_error('Gửi tin nhắn thất bại', context);
          } else if (state.deleteState == false) {
            showSnackBar.show_error('Xoá tin nhắn thất bại', context);
          }
        },
        child: BlocBuilder<MessageBloc, MessageState>(
          buildWhen:
              (previous, current) =>
                  previous.listMessages != current.listMessages ||
                  previous.isLoading != current.isLoading ||
                  previous.error != current.error,
          builder: (context, state) {
            log(state.toString());
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            } else if (state.error != null) {
              return Center(
                child: Text(
                  'Lỗi tải tin nhắn: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              final List<MessageItem> messages = state.listMessages;
              log(messages.toString());

              // Jump to bottom chỉ lần đầu load
              if (_isFirstLoad && messages.isNotEmpty) {
                _isFirstLoad = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                });
              }

              return Column(
                children: [
                  messages.isEmpty
                      ? Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Bắt đầu cuộc trò chuyện với ${widget.user.userName}!',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                      : Expanded(
                        child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          physics: const ClampingScrollPhysics(),
                          itemCount:
                              messages.length +
                              (_isUploadingImage ? 1 : 0) +
                              (_isUploadingVideo ? 1 : 0) +
                              (_isUploadingAudio ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Hiển thị placeholder cho uploading audio
                            if (_isUploadingAudio && index == 0) {
                              return _buildUploadingPlaceholder(
                                'Đang gửi audio...',
                                Icons.audiotrack,
                              );
                            }
                            // Hiển thị placeholder cho uploading video
                            if (_isUploadingVideo &&
                                index == (_isUploadingAudio ? 1 : 0)) {
                              return _buildUploadingPlaceholder(
                                'Đang gửi video...',
                                Icons.videocam,
                              );
                            }
                            // Hiển thị placeholder cho uploading image
                            if (_isUploadingImage &&
                                index ==
                                    (_isUploadingAudio ? 1 : 0) +
                                        (_isUploadingVideo ? 1 : 0)) {
                              return _buildUploadingPlaceholder(
                                'Đang gửi ảnh...',
                                Icons.image,
                              );
                            }
                            // Tính toán index thực cho messages (đảo ngược)
                            final messageIndex =
                                messages.length -
                                1 -
                                (index -
                                    (_isUploadingImage ? 1 : 0) -
                                    (_isUploadingVideo ? 1 : 0) -
                                    (_isUploadingAudio ? 1 : 0));
                            // Hiển thị message bình thường
                            return MessageBubble(
                              message: messages[messageIndex],
                              currentUserId:
                                  _firebaseAuth.currentUser?.uid ?? '',
                              chatId: widget.chatId,
                            );
                          },
                        ),
                      ),
                  // Hiển thị Audio Recorder hoặc Message Input
                  _isRecordingAudio
                      ? AudioRecorderWidget(
                        onSend: _sendAudioMessage,
                        onCancel: _cancelAudioRecording,
                      )
                      : MessageInput(
                        textController: _textController,
                        onSendMessage: sendMessageText,
                        onAttachmentPressed: showAttachmentOptions,
                      ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
