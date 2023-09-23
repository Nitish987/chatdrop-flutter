import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class FansRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = FansRepository._();

  FansRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> listFollowers(String uid, {required int page}) async {
    final response = await _apiClient.get(
        path: 'fanfollowing/v1/followers/list/',
        queryParams: {'of': uid, 'page': page}
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listFollowings(String uid, {required int page}) async {
    final response = await _apiClient.get(
        path: 'fanfollowing/v1/followings/list/',
        queryParams: {'of': uid, 'page': page}
    );
    return response.data;
  }
}