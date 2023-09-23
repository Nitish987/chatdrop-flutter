import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SearchRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = SearchRepository._();

  SearchRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> searchProfiles(String query, {required int page}) async {
    var response = await _apiClient.get(
        path: 'search/v1/search/profiles/',
      queryParams: {'q': query, 'page': page},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> searchAudios(String query, {required int page}) async {
    var response = await _apiClient.get(
      path: 'search/v1/search/audios/',
      queryParams: {'q': query, 'page': page},
    );
    return response.data;
  }
}
