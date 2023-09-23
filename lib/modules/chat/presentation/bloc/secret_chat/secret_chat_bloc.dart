import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/message_model/secret_message_model.dart';
import 'secret_chat_event.dart';
import 'secret_chat_state.dart';

class SecretChatBloc extends Bloc<SecretChatEvent, SecretChatState> {
  late List<SecretMessageModel> messages;

  SecretChatBloc() : super(SecretChatInitialState()) {
    messages = [];
    addChatEvent();
    listChatEvent();
    readChatEvent();
    deleteChatEvent();
    clearChatEvent();
    messageSelectionEvent();
    clearSelectionEvent();
    recoverInterruptedEvent();
  }

  void listChatEvent() {
    on<ListSecretChatEvent>((event, emit) {
      messages = event.messages;
      emit(SecretChatListState(messages));
    });
  }

  void addChatEvent() {
    on<AddSecretChatEvent>((event, emit) {
      messages.add(event.message);
      emit(SecretChatListState(messages));
    });
  }

  void readChatEvent() {
    on<ReadSecretChatEvent>((event, emit) {
      messages = messages.map((message) {
        message.isRead = true;
        return message;
      }).toList();
      emit(SecretChatListState(messages));
    });
  }

  void deleteChatEvent() {
    on<DeleteSecretChatEvent>((event, emit) {
      for (SecretMessageModel message in event.selectedMessages) {
        int index = messages.indexWhere((element) => element.id == message.id);
        if(messages[index].isDeleted!) {
          messages.removeAt(index);
        } else {
          messages[index].isDeleted = true;
        }
      }
      emit(SecretChatListState(messages));
    });
  }

  void clearChatEvent() {
    on<ClearSecretChatEvent>((event, emit) {
      messages.clear();
      emit(SecretChatListState(messages));
    });
  }

  void messageSelectionEvent() {
    on<SecretMessageSelectionEvent>((event, emit) {
      int index = messages.indexWhere((element) => element.id == event.id);
      if (messages[index].isSelected!) {
        messages[index].isSelected = false;
        event.selectedMessages.removeWhere((element) => element.id == event.id);
      } else {
        messages[index].isSelected = true;
        event.selectedMessages.add(messages[index]);
      }
      emit(SecretChatListState(messages));
    });
  }

  void clearSelectionEvent() {
    on<ClearSelectionEvent>((event, emit) {
      messages = messages.map((message) {
        message.isSelected = false;
        return message;
      }).toList();
      event.selectedMessages.clear();
      emit(SecretChatListState(messages));
    });
  }

  void recoverInterruptedEvent() {
    on<RecoverInterruptedMessageEvent>((event, emit) {
      int index = messages.indexWhere((message) => message.id == event.message.id);
      if (messages[index].isInterrupted!) {
        messages[index] = event.message;
      }
      emit(SecretChatListState(messages));
    });
  }
}
