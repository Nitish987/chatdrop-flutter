import 'package:chatdrop/modules/chat/presentation/cubit/can_chat/can_chat_state.dart';
import 'package:chatdrop/shared/services/secret_chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanChatCubit extends Cubit<CanChatState> {
  final SecretChatService _chatService = SecretChatService();

  CanChatCubit(String remoteUserUid) : super(CanChatState.initial) {
    updateStatus(remoteUserUid);
  }

  void updateStatus(String remoteUserUid) async {
    if(await _chatService.canChat(remoteUserUid)) {
      emit(CanChatState.available);
    } else {
      emit(CanChatState.unavailable);
    }
  }
}