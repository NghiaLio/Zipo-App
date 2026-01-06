import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/chat_models.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatEvent {}

class ChatsUpdatedEvent extends ChatEvent {
  final List<ChatItem> chats;
  ChatsUpdatedEvent(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatsErrorEvent extends ChatEvent {
  final String error;
  ChatsErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class UpdateChatEvent extends ChatEvent {
  final String chatId;
  final String newMessage;

  UpdateChatEvent(this.chatId, this.newMessage);

  @override
  List<Object?> get props => [chatId, newMessage];
}

class CreateChatEvent extends ChatEvent {
  final List<String> participants;

  CreateChatEvent(this.participants);

  @override
  List<Object?> get props => [participants];
}

class UnloadChatsEvent extends ChatEvent {}
