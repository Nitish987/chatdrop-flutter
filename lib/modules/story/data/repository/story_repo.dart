import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:dio/dio.dart';

class StoryRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = StoryRepository._();

  StoryRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> addStory(String contentType, {String? imagePath, String text = '', String? videoPath}) async {
    Map<String, dynamic> data = {};

    if (contentType != 'TEXT') {
      data['text'] = text;
    }

    if(contentType == 'TEXT' || contentType == "PHOTO") {
      data['photo'] = await MultipartFile.fromFile(
        imagePath!,
        filename: imagePath.split('/').last,
      );
    }

    if (contentType == 'VIDEO') {
      data['video'] = await MultipartFile.fromFile(
        videoPath!,
        filename: videoPath.split('/').last,
      );
    }

    final response = await _apiClient.multiPartPost(
      path: 'story/v2/story/add/',
      data: data,
      queryParams: {'content_type': contentType},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listStory() async {
    final response = await _apiClient.get(
      path: 'story/v1/story/list/',
      queryParams: {'of': UserService.authHeaders['uid']},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteStory(String storyId) async {
    final response = await _apiClient.delete(
      path: 'story/v1/story/$storyId/delete/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> addStoryView(String storyId) async {
    final response = await _apiClient.post(
      path: 'story/v1/story/$storyId/viewer/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listStoryViewers(String storyId) async {
    final response = await _apiClient.get(
      path: 'story/v1/story/$storyId/viewer/',
    );
    return response.data;
  }
}
