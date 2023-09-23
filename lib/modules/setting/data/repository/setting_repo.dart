import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SettingRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = SettingRepository._();

  SettingRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> updateProfileSettings(String key, dynamic value) async {
    var response = await _apiClient.put(
      path: 'account/v1/settings/',
      data: {
        'key': key,
        'value': value,
      },
    );
    return response.data;
  }
}