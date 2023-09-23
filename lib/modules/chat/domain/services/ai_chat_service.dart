import 'package:chatdrop/infra/utilities/aes.dart';
import 'package:chatdrop/modules/chat/data/repository/ai_chat_repo.dart';
import 'package:chatdrop/modules/chat/data/models/message_model/ai_message_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class AiChatService {
  final AiChatRepository _chatMessageRepository = AiChatRepository();

  Future<void> init() async {
    await _chatMessageRepository.init();
  }

  Future<AiMessageModel> storeMessage(AiMessageModel model) async {
    AiMessageModel modelCopy = model.copy();

    // encrypting and storing
    modelCopy.content = Aes256.encrypt(modelCopy.content!, UserService.encryptionKey);
    await _chatMessageRepository.storeMessage(modelCopy);
    return model;
  }

  Future<List<AiMessageModel>> retrieveMessages() async {
    List<AiMessageModel> messages = await _chatMessageRepository.retrieveMessages();
    messages = messages.map((model) {
      model.content = Aes256.decrypt(model.content!, UserService.encryptionKey);
      return model;
    }).toList();
    return messages;
  }

  Future<void> deleteMessages(List<AiMessageModel> messages) async {
    await _chatMessageRepository.deleteMessages(messages);
  }

  Future<void> clearChats() async {
    await _chatMessageRepository.clearChats();
  }

  void close() async {
    _chatMessageRepository.close();
  }
}