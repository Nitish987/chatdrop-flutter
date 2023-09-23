import '../../../../infra/services/api_client.dart';
import '../../../../shared/services/user_service.dart';

class PrivacyRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = PrivacyRepository._();

  PrivacyRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> getBlockUserList() async {
    final response = await _apiClient.get(
      path: 'privacy/v1/block/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> blockUser(String uid) async {
    var response = await _apiClient.post(
      path: 'privacy/v1/block/',
      queryParams: {'to': uid},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> unblockUser(String uid) async {
    var response = await _apiClient.delete(
      path: 'privacy/v1/block/',
      queryParams: {'to': uid},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> reportUser(String uid, String message) async {
    var response = await _apiClient.post(
      path: 'privacy/v1/report/',
      queryParams: {'to': uid},
      data: {'message': message},
    );
    return response.data;
  }
}