import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';

abstract class AiChatEvent {}

class AiChatListEvent extends AiChatEvent {
  List<AiMessageModel> messages;
  AiChatListEvent(this.messages);
}

class AddAiMessageEvent extends AiChatEvent {
  AiMessageModel message;
  AddAiMessageEvent(this.message);
}

class DeleteAiMessageEvent extends AiChatEvent {
  List<AiMessageModel> selectedMessages;
  DeleteAiMessageEvent(this.selectedMessages);
}