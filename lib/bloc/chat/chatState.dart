import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/chat_models.dart';

class ChatState extends Equatable {
  final List<ChatItem> chats;
  final bool isLoading;
  final String? error;
  final bool? deleteState;

  const ChatState({
    this.chats = const [],
    this.isLoading = true,
    this.error,
    this.deleteState,
  });

  ChatState copyWith({
    List<ChatItem>? chats,
    bool? isLoading,
    String? error,
    bool? deleteState,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      deleteState: deleteState ?? this.deleteState,
    );
  }

  @override
  List<Object?> get props => [chats, isLoading, error, deleteState];
}
