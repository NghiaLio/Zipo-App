import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/message_models.dart';

class MessageState extends Equatable{
  final List<MessageItem> listMessages;
  final bool isLoading;
  final String? error;
  final bool? deleteState;
  final bool? sendState;

  const MessageState({
    this.listMessages = const [],
    this.isLoading = false,
    this.error,
    this.deleteState,
    this.sendState,
  });

  MessageState copyWith({
    List<MessageItem>? listMessages,
    bool? isLoading,
    String? error,
    bool? deleteState,
    bool? sendState,
  }) {
    return MessageState(
      listMessages: listMessages ?? this.listMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      deleteState: deleteState ?? this.deleteState,
      sendState: sendState ?? this.sendState,
    );
  }

  @override
  List<Object?> get props => [listMessages, isLoading, error, deleteState, sendState];
}