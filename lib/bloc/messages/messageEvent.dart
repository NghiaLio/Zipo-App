import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:maintain_chat_app/models/message_models.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends MessageEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}
class UpdateListMessagesEvent extends MessageEvent {
  final List<MessageItem> listMessages;

  const UpdateListMessagesEvent(this.listMessages);

  @override
  List<Object> get props => [listMessages];
}

class MessagesErrorEvent extends MessageEvent {
  final String error;

  const MessagesErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}

// create message
class CreateMessageEvent extends MessageEvent {
  final MessageItem message;
  final String chatId;

  const CreateMessageEvent(this.message, this.chatId);

  @override
  List<Object> get props => [message, chatId];
}

// undo message
class UndoMessageEvent extends MessageEvent {
  final String chatId;
  final Timestamp sendAt;
  const UndoMessageEvent(this.chatId, this.sendAt);

  @override
  List<Object> get props => [chatId, sendAt];
}

// reply message
class ReplyMessageEvent extends MessageEvent {
  final String messageId;
  final String replyContent;

  const ReplyMessageEvent(this.messageId, this.replyContent);

  @override
  List<Object> get props => [messageId, replyContent];
}