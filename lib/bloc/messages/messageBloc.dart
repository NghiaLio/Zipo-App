import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageEvent.dart';
import 'package:maintain_chat_app/bloc/messages/messageState.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/repositories/messageRepo.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo messageRepository;
  StreamSubscription<List<MessageItem>>? _messagesSubscription;

  MessageBloc({required this.messageRepository}) : super(MessageState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<UpdateListMessagesEvent>(_onMessagesUpdated);
    on<MessagesErrorEvent>(_onMessagesError);
    on<CreateMessageEvent>(_onSendMessage);
    on<UndoMessageEvent>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageState(isLoading: true));

    try {
      // Cancel previous subscription if exists
      await _messagesSubscription?.cancel();

      // Listen to the stream from repository
      _messagesSubscription = messageRepository
          .loadMessages(event.chatId)
          .listen(
            (messages) {
              add(UpdateListMessagesEvent(messages));
            },
            onError: (error) {
              add(MessagesErrorEvent(error.toString()));
            },
          );
    } catch (e) {
      emit(MessageState(error: e.toString(), isLoading: false));
    }
  }

  void _onMessagesUpdated(
    UpdateListMessagesEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(
      state.copyWith(
        listMessages: event.listMessages,
        isLoading: false,
        error: null,
      ),
    );
  }

  void _onMessagesError(MessagesErrorEvent event, Emitter<MessageState> emit) {
    emit(state.copyWith(error: event.error, isLoading: false));
  }

  void _onSendMessage(
    CreateMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    try {
      // emit(state.copyWith(isLoading: true));
      await messageRepository.createMessage(event.message, event.chatId);
      emit(
        state.copyWith(isLoading: false, deleteState: null, sendState: true),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, sendState: false, error: e.toString()),
      );
    }
  }

  void _onDeleteMessage(
    UndoMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    try {
      // emit(state.copyWith(isLoading: true));
      await messageRepository.undoMessage(event.chatId, event.sendAt);
      emit(state.copyWith(isLoading: false, deleteState: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          deleteState: false,
          error: e.toString(),
        ),
      );
    }
  }
}
