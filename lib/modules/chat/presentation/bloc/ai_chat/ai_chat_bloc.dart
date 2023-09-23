import 'package:chatdrop/modules/chat/presentation/bloc/ai_chat/ai_chat_event.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  late List<AiMessageModel> messages;

  AiChatBloc() : super(InitialAiChatState()) {
    messages = [];
    addChatEvent();
    listChatEvent();
    deleteChatEvent();
  }

  void listChatEvent() {
    on<AiChatListEvent>((event, emit) {
      messages = event.messages;
      emit(AiChatListState(messages));
    });
  }

  void addChatEvent() {
    on<AddAiMessageEvent>((event, emit) {
      messages.add(event.message);
      emit(AiChatListState(messages));
    });
  }

  void deleteChatEvent() {
    on<DeleteAiMessageEvent>((event, emit) {
      for (AiMessageModel message in event.selectedMessages) {
        int index = messages.indexWhere((element) => element.id == message.id);
        messages.removeAt(index);
      }
      event.selectedMessages.clear();
      emit(AiChatListState(messages));
    });
  }
}