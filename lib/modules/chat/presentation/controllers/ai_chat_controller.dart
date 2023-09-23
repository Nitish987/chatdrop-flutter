import 'package:chatdrop/modules/chat/domain/services/ai_chat_service.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:chatdrop/shared/services/chatgpt_service.dart';

class AiChatController {
  final ChatGptService _gptService = ChatGptService();
  final AiChatService _aiChatService = AiChatService();
  final List<AiMessageModel> selectedMessages = <AiMessageModel> [];

  Future<void> initialize() async {
    await _aiChatService.init();
  }

  Future<AiMessageModel> replyForMessage(AiMessageModel message) async {
    storeMessage(message);
    String reply = await _gptService.generateReply(message.content!);
    int time = DateTime.now().millisecondsSinceEpoch;
    AiMessageModel response = AiMessageModel(
      id: time,
      senderUid: 'olivia_ai',
      contentType: 'TEXT',
      content: reply,
      time: time,
    );
    storeMessage(response);
    return response;
  }

  Future<List<AiMessageModel>> retrieveMessages() async {
    List<AiMessageModel> messages = await _aiChatService.retrieveMessages();
    return messages;
  }

  void storeMessage(AiMessageModel message) async {
    await _aiChatService.storeMessage(message);
  }

  Future<void> deleteMessages() async {
    await _aiChatService.deleteMessages(selectedMessages);
  }

  Future<void> clearChats() async {
    await _aiChatService.clearChats();
  }

  void dispose() {
    _aiChatService.close();
  }
}