import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class FeedRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = FeedRepository._();

  FeedRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> getTimelineFeeds({required int page}) async {
    final response = await _apiClient.get(
      path: 'feeds/v3/feeds/timeline/',
      queryParams: {'page': page},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> getStoryFeeds() async {
    final response = await _apiClient.get(
      path: 'feeds/v1/feeds/storyline/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> getReelsFeeds({required int page}) async {
    final response = await _apiClient.get(
      path: 'feeds/v1/feeds/reelline/',
      queryParams: {'page': page},
    );
    return response.data;
  }
}