import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';

abstract class AiChatState {}

class InitialAiChatState extends  AiChatState {}

class AiChatListState extends AiChatState {
  List<AiMessageModel> messages;
  AiChatListState(this.messages);
}

class LoadingAiChatListState extends AiChatState {}

class FailedAiChatListState extends AiChatState {}