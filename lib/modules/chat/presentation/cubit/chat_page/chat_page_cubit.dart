import 'package:chatdrop/modules/chat/presentation/cubit/chat_page/chat_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState.initial);

  setMessagesSelected(int selectedMessagesSize) {
    if (selectedMessagesSize == 1) {
      emit(ChatPageState.onlyOneMessageSelected);
    } else {
      emit(ChatPageState.manyMessagesSelected);
    }
  }

  setMessagesUnselected() {
    emit(ChatPageState.messageUnselected);
  }
}