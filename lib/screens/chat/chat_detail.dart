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
import 'package:maintain_chat_app/l10n/app_localizations.dart';
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
  Map<String, String>? _replyingTo;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Khởi tạo MessageService và load messages
    final messageBloc = context.read<MessageBloc>();
    messageBloc.messageRepository.init(widget.chatId, widget.user.id);
    messageBloc.add(LoadMessagesEvent(widget.chatId));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      final state = context.read<MessageBloc>().state;
      if (state.listMessages.isNotEmpty) {
        setState(() {
          _isLoadingMore = true;
        });
        // Lấy tin nhắn cũ nhất (vì reverse: true nên item cuối của list là tin nhắn cũ nhất)
        final lastMessage = state.listMessages.last;
        context.read<MessageBloc>().add(
          LoadMoreMessages(widget.chatId, lastMessage.sendAt),
        );

        // Reset flag sau một khoảng thời gian hoặc khi state thay đổi
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        });
      }
    }
  }

  void sendMessageText() async {
    final content = _textController.text.trim();
    if (content.isEmpty) return;

    final MessageItem newMessage = MessageItem(
      senderID: _firebaseAuth.currentUser?.uid ?? '',
      content: content,
      type: MessageType.Text,
      sendAt: Timestamp.fromDate(DateTime.now()),
      isSeen: false,
      isLatest: true,
      replyingTo: _replyingTo,
    );

    final messageBloc = context.read<MessageBloc>();
    messageBloc.add(CreateMessageEvent(newMessage, widget.chatId));

    setState(() {
      _textController.clear();
      _replyingTo = null; // Clear reply state after sending
    });
  }

  void _onReply(MessageItem message) {
    setState(() {
      _replyingTo = {
        'authorMessage':
            message.senderID == _firebaseAuth.currentUser?.uid
                ? AppLocalizations.of(context)!.me_label_chat
                : widget.user.userName,
        'content': _getReplyMetadata(message),
      };
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  String _getReplyMetadata(MessageItem message) {
    switch (message.type) {
      case MessageType.Text:
        return message.content;
      case MessageType.Image:
        return AppLocalizations.of(context)!.image_tag;
      case MessageType.Video:
        return AppLocalizations.of(context)!.video_tag;
      case MessageType.Audio:
        return AppLocalizations.of(context)!.audio_tag;
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
      showSnackBar.show_error(
        '${AppLocalizations.of(context)!.send_image_failed_chat}: $e',
        context,
      );
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
      showSnackBar.show_error(
        '${AppLocalizations.of(context)!.send_video_failed_chat}: $e',
        context,
      );
    } finally {
      setState(() {
        _isUploadingVideo = false;
      });
    }
  }

  Widget _buildUploadingPlaceholder(String text, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
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
                    color: theme.disabledColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF9C27B0),
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.select_image,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onTap: sendMessageImage,
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE91E63),
                    child: Icon(Icons.videocam, color: Colors.white),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.select_video,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onTap: sendMessageVideo,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: const Icon(Icons.mic, color: Colors.white),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.record_audio,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
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
      showSnackBar.show_error(
        '${AppLocalizations.of(context)!.send_audio_failed_chat}: $e',
        context,
      );
    } finally {
      setState(() {
        _isUploadingAudio = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            await context.read<MessageBloc>().messageRepository.dispose();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.onSurface.withOpacity(0.1),
              backgroundImage:
                  widget.user.avatarUrl?.isNotEmpty ?? false
                      ? CachedNetworkImageProvider(widget.user.avatarUrl!)
                      : null,
              child:
                  widget.user.avatarUrl?.isEmpty ?? true
                      ? Icon(Icons.person, color: theme.disabledColor)
                      : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.userName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.isOnline ?? false
                      ? AppLocalizations.of(context)!.active_now_label
                      : AppLocalizations.of(context)!.offline_label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        widget.user.isOnline ?? false
                            ? Colors.green
                            : theme.disabledColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
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
                  PopupMenuItem<String>(
                    value: 'view_profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: colorScheme.onSurface),
                        const SizedBox(width: 12),
                        Text(AppLocalizations.of(context)!.view_profile_menu),
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
            showSnackBar.show_error(
              AppLocalizations.of(context)!.send_message_failed,
              context,
            );
          } else if (state.deleteState == false) {
            showSnackBar.show_error(
              AppLocalizations.of(context)!.delete_message_failed,
              context,
            );
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
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            } else if (state.error != null) {
              return Center(
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.load_messages_error(state.error.toString()),
                  style: TextStyle(color: colorScheme.error),
                ),
              );
            } else {
              final List<MessageItem> messages = state.listMessages;
              log(messages.toString());

              return Column(
                children: [
                  messages.isEmpty
                      ? Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.start_chat_hint(widget.user.userName),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
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
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              messages.length +
                              (_isUploadingImage ? 1 : 0) +
                              (_isUploadingVideo ? 1 : 0) +
                              (_isUploadingAudio ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Hiển thị placeholder cho uploading audio
                            if (_isUploadingAudio && index == 0) {
                              return _buildUploadingPlaceholder(
                                AppLocalizations.of(
                                  context,
                                )!.sending_audio_status,
                                Icons.audiotrack,
                              );
                            }
                            // Hiển thị placeholder cho uploading video
                            if (_isUploadingVideo &&
                                index == (_isUploadingAudio ? 1 : 0)) {
                              return _buildUploadingPlaceholder(
                                AppLocalizations.of(
                                  context,
                                )!.sending_video_status,
                                Icons.videocam,
                              );
                            }
                            // Hiển thị placeholder cho uploading image
                            if (_isUploadingImage &&
                                index ==
                                    (_isUploadingAudio ? 1 : 0) +
                                        (_isUploadingVideo ? 1 : 0)) {
                              return _buildUploadingPlaceholder(
                                AppLocalizations.of(
                                  context,
                                )!.sending_image_status,
                                Icons.image,
                              );
                            }

                            // Tính toán index cho messages
                            final messageIndex =
                                index -
                                (_isUploadingImage ? 1 : 0) -
                                (_isUploadingVideo ? 1 : 0) -
                                (_isUploadingAudio ? 1 : 0);

                            if (messageIndex < 0 ||
                                messageIndex >= messages.length) {
                              return const SizedBox.shrink();
                            }

                            // Hiển thị message bình thường
                            return MessageBubble(
                              message: messages[messageIndex],
                              currentUserId:
                                  _firebaseAuth.currentUser?.uid ?? '',
                              chatId: widget.chatId,
                              recipientUser: widget.user,
                              onReply: _onReply,
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
                        replyingTo: _replyingTo,
                        onCancelReply: _cancelReply,
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
