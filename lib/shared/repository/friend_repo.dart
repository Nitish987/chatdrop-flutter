import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class FriendRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = FriendRepository._();

  FriendRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final response = await _apiClient.get(
      path: 'account/v1/profile/$uid/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> sendFriendRequest(String uid) async {
    var response = await _apiClient.post(
      path: 'friend/v1/friend/request/send/',
      queryParams: {'to': uid},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> unfriend(String uid) async {
    var response = await _apiClient.delete(
      path: 'friend/v1/unfriend/',
      queryParams: {'to': uid},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> acceptRequest(int requestId) async {
    var response = await _apiClient.post(
      path: 'friend/v1/friend/request/$requestId/accept/',
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listFriends(String uid, {required int page}) async {
    var response = await _apiClient.get(
      path: 'friend/v1/friend/list/',
      queryParams: {'of': uid, 'page': page},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> checkFriend(String uid) async {
    var response = await _apiClient.get(
      path: 'friend/v1/friend/check/',
      queryParams: {'of': uid},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> sendFollowRequest(String uid) async {
    var response = await _apiClient.post(
      path: 'fanfollowing/v1/follow/request/send/',
      queryParams: {'to': uid},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> acceptFollowRequest(int requestId) async {
    var response = await _apiClient.post(
      path: 'fanfollowing/v1/follow/request/$requestId/accept/',
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> unfollow(String uid) async {
    var response = await _apiClient.delete(
      path: 'fanfollowing/v1/unfollow/',
      queryParams: {'to': uid},
    );
    return response.data;
  }
}
