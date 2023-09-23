import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SecretChatRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = SecretChatRepository._();

  SecretChatRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> canChat(String uid) async {
    final response = await _apiClient.get(
        path: 'chat/v1/secret/canchat/',
        queryParams: {'to': uid},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> sendMessage(String uid, Map<String, dynamic> content) async {
    final response = await _apiClient.post(
        path: 'chat/v1/secret/chat/message/',
        queryParams: {'to': uid},
        data: {'content': content},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> messageReadSignal(String uid) async {
    final response = await _apiClient.put(
      path: 'chat/v1/secret/chat/message/',
      queryParams: {'to': uid},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> messageDeleteSignal(String uid, int messageId) async {
    final response = await _apiClient.delete(
      path: 'chat/v1/secret/chat/message/',
      queryParams: {'to': uid, 'id': messageId},
    );
    return response.data;
  }
}