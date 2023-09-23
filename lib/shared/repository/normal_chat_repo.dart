import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class NormalChatRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = NormalChatRepository._();

  NormalChatRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> sendMessage(String uid, Map<String, dynamic> message) async {
    final response = await _apiClient.post(
      path: 'chat/v1/normal/chat/message/',
      queryParams: {'to': uid},
      data: {'message': message},
    );
    return response.data;
  }
}