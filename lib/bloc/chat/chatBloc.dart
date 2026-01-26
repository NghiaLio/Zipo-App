import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatEvent.dart';
import 'package:maintain_chat_app/bloc/chat/chatState.dart';
import 'package:maintain_chat_app/models/chat_models.dart';
import 'package:maintain_chat_app/repositories/chatRepo.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepository;
  StreamSubscription<List<ChatItem>>? _chatsSubscription;

  ChatBloc({required this.chatRepository}) : super(ChatState()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<ChatsUpdatedEvent>(_onChatsUpdated);
    on<ChatsErrorEvent>(_onChatsError); // ✅ Thêm handler cho error event
    on<DeleteChatEvent>(_onDeleteChat);
    on<UpdateChatEvent>(_onUpdateChat);
    on<CreateChatEvent>(_onCreateChat);
    on<UnloadChatsEvent>(_onUnloadChats);
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Cancel previous subscription if exists
      await _chatsSubscription?.cancel();

      // Listen to the stream from repository
      _chatsSubscription = chatRepository.loadChats().listen(
        (chats) {
          // When stream emits new data, add ChatsUpdatedEvent
          add(ChatsUpdatedEvent(chats)); // ✅ Sử dụng add() thay vì emit()
        },
        onError: (error) {
          add(
            ChatsErrorEvent(error.toString()),
          ); // ✅ Sử dụng add() thay vì emit()
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onChatsUpdated(ChatsUpdatedEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(chats: event.chats, isLoading: false, error: null));
  }

  void _onChatsError(ChatsErrorEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(error: event.error, isLoading: false));
  }

  Future<void> _onUnloadChats(
    UnloadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _chatsSubscription?.cancel();
    _chatsSubscription = null;
    emit(ChatState());
  }

  Future<void> _onDeleteChat(
    DeleteChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      await chatRepository.deleteChat(event.chatId);

      // Sau khi xóa, stream sẽ tự động cập nhật danh sách chat
      emit(state.copyWith(deleteState: true, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Error deleting chat: ${e.toString()}',
          deleteState: false,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _onUpdateChat(
    UpdateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Implementation for update chat
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final chatId = await chatRepository.createChat(event.participants);

      if (chatId.isNotEmpty) {
        // Chat đã được tạo thành công, stream sẽ tự động cập nhật
        // Không cần gọi LoadChatsEvent vì đã có stream đang lắng nghe
        emit(state.copyWith(isLoading: false, deleteState: null));
      } else {
        emit(state.copyWith(error: 'Failed to create chat', isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Error creating chat: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
