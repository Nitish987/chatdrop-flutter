import 'package:chatdrop/infra/services/api_client.dart';

import '../services/user_service.dart';

class ChatGptRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = ChatGptRepository._();

  ChatGptRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> generateReply(String message) async {
    var response = await _apiClient.post(
      path: 'chat/v1/chatgpt/chat/message/',
      data: {'message': message},
    );
    return response.data;
  }
}