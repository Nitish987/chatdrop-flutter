import 'package:chatdrop/modules/dashboard/presentation/bloc/recent_chats/recent_chats_event.dart';
import 'package:chatdrop/modules/dashboard/presentation/bloc/recent_chats/recent_chats_state.dart';
import 'package:chatdrop/shared/models/recent_secret_chat_model/recent_secret_chat_model.dart';
import 'package:chatdrop/shared/services/secret_chat_message_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentChatsBloc extends Bloc<RecentChatsEvent, RecentChatsState> {
  final SecretChatMessageService _chatMessageService = SecretChatMessageService();

  RecentChatsBloc() : super(RecentChatsLoadingListState()) {
    recentChatList();
  }

  void recentChatList() {
    on<ListRecentChatsEvent>((event, emit) async {
      await _chatMessageService.init();
      List<RecentSecretChatModel> recentChats = await _chatMessageService.retrieveRecentChats();
      await _chatMessageService.close();
      emit(RecentChatsListState(recentChats));
    });
  }
}