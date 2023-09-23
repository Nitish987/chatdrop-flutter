import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/message_model/message_model.dart';
import '../repository/normal_chat_repo.dart';

class NormalChatService {
  final NormalChatRepository _normalChatRepository = NormalChatRepository.instance;

  Future<bool> sendMessage(MessageModel message) async {
    try {
      final response = ResponseCollector.collect(
        await _normalChatRepository.sendMessage(message.chatWith!, message.toJson()),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}