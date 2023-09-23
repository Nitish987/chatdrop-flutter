import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:dio/dio.dart';

class ReelRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = ReelRepository._();

  ReelRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> addReel(String visibility, String hashtags, String videoPath, String thumbnailPath, double videoAspectRatio, {
    String text = '',
    int audioId = 0,
  }) async {
    Map<String, dynamic> data = {
      'text': text,
      'hashtags': hashtags,
      'visibility': visibility,
      'video': MultipartFile.fromFileSync(videoPath, filename: videoPath.split('/').last),
      'thumbnail': MultipartFile.fromFileSync(thumbnailPath, filename: thumbnailPath.split('/').last),
      'aspect_ratio': videoAspectRatio,
      'audio_id': audioId,
    };

    var response = await _apiClient.multiPartPost(
      path: 'reel/v1/reel/add/',
      data: data,
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> addReelView(String reelId) async {
    final response = await _apiClient.post(
      path: 'reel/v1/reel/$reelId/viewer/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> viewReel(String reelId) async {
    final response = await _apiClient.get(
      path: 'reel/v1/reel/$reelId/view/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> changeReelVisibility(String reelId, String visibility) async {
    final response = await _apiClient.put(
      path: 'reel/v1/reel/$reelId/visibility/',
      queryParams: {'vbt': visibility},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listReel(String uid, {required int page}) async {
    final response = await _apiClient.get(
        path: 'reel/v1/reel/list/',
        queryParams: {'of': uid, 'page': page}
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteReel(String reelId) async {
    final response = await _apiClient.delete(
      path: 'reel/v1/reel/$reelId/delete/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> likeReel(String reelId, String liked) async {
    final response = await _apiClient.post(
      path: 'reel/v1/reel/$reelId/like/',
      data: {'type': liked},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> dislikeReel(String reelId) async {
    final response = await _apiClient.delete(
      path: 'reel/v1/reel/$reelId/like/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> getReelComments(String reelId) async {
    final response = await _apiClient.get(
      path: 'reel/v1/reel/$reelId/comment/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> addReelComment(String reelId, String text) async {
    final response = await _apiClient.post(
      path: 'reel/v1/reel/$reelId/comment/',
      data: {'text': text},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteReelComment(String reelId, String commentId) async {
    final response = await _apiClient.delete(
      path: 'reel/v1/reel/$reelId/comment/$commentId/delete/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> likeReelComment(String commentId, String liked) async {
    final response = await _apiClient.post(
      path: 'reel/v1/reel/comment/$commentId/like/',
      data: {'type': liked},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> dislikeReelComment(String commentId) async {
    final response = await _apiClient.delete(
      path: 'reel/v1/reel/comment/$commentId/like/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> addAudio(String name, String audioPath, int duration) async {
    final response = await _apiClient.multiPartPost(
        path: 'reel/v1/audio/add/',
        data: {
          'name': name,
          'audio': MultipartFile.fromFileSync(audioPath, filename: audioPath.split('/').last),
          'duration': duration,
        }
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listAudio() async {
    final response = await _apiClient.get(
        path: 'reel/v1/audio/list/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteAudio(int audioId) async {
    final response = await _apiClient.delete(
      path: 'reel/v1/audio/$audioId/delete/',
    );
    return response.data;
  }
}
