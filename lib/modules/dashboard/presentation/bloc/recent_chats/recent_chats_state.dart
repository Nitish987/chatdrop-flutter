import 'package:chatdrop/shared/models/recent_secret_chat_model/recent_secret_chat_model.dart';

abstract class RecentChatsState {}

class RecentChatsLoadingListState extends RecentChatsState {}

class RecentChatsListState extends RecentChatsState {
  List<RecentSecretChatModel> recentChats;
  RecentChatsListState(this.recentChats);
}