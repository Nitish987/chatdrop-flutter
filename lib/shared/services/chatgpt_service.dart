import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/repository/chatgpt_repo.dart';

class ChatGptService {
  final ChatGptRepository _gptRepository = ChatGptRepository.instance;

  /// generates the reply according to messages
  Future<String> generateReply(String message) async {
    try {
      final response = ResponseCollector.collect(
        await _gptRepository.generateReply(message),
      );
      if (response.success) {
        return response.data?['reply'];
      }
      return 'Chat Message limit exceeded. I can only reply for 25 messages per day. See you tomorrow.';
    } catch (e) {
      return 'Chat Message limit exceeded. I can only reply for 25 messages per day. See you tomorrow.';
    }
  }
}