import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:dio/dio.dart';

class PostRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = PostRepository._();

  PostRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> addPost(String visibility, String contentType, String hashtags, {
    String? text, List<String>? photosPath, String? videoPath, List<double>? photoAspectRatios, double? videoAspectRatio, String? thumbnailPath
  }) async {
    Map<String, dynamic> data = {
      'hashtags': hashtags,
      'visibility': visibility,
    };
    if (contentType == 'TEXT' ||
        contentType == 'TEXT_PHOTO' ||
        contentType == 'TEXT_VIDEO') {
      data['text'] = text!;
    }
    if (contentType == 'PHOTO' || contentType == 'TEXT_PHOTO') {
      data['photos'] = photosPath!.map((e) => MultipartFile.fromFileSync(e, filename: e.split('/').last)).toList();
      data['aspect_ratios'] = photoAspectRatios;
    }
    if (contentType == 'VIDEO' || contentType == 'TEXT_VIDEO') {
      data['video'] = MultipartFile.fromFileSync(videoPath!, filename: videoPath.split('/').last);
      data['aspect_ratio'] = videoAspectRatio;
      data['thumbnail'] = MultipartFile.fromFileSync(thumbnailPath!, filename: thumbnailPath.split('/').last);
    }

    var response = await _apiClient.multiPartPost(
      path: 'post/v3/post/add/',
      data: data,
      queryParams: {'content_type': contentType},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> viewPost(String postId) async {
    final response = await _apiClient.get(
        path: 'post/v2/post/$postId/view/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> changePostVisibility(String postId, String visibility) async {
    final response = await _apiClient.put(
      path: 'post/v1/post/$postId/visibility/',
      queryParams: {'vbt': visibility},
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> listPost(String uid, {required int page}) async {
    final response = await _apiClient.get(
      path: 'post/v3/post/list/',
      queryParams: {'of': uid, 'page': page}
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deletePost(String postId) async {
    final response = await _apiClient.delete(
      path: 'post/v1/post/$postId/delete/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> likePost(String postId, String liked) async {
    final response = await _apiClient.post(
      path: 'post/v1/post/$postId/like/',
      data: {'type': liked},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> dislikePost(String postId) async {
    final response = await _apiClient.delete(
      path: 'post/v1/post/$postId/like/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> getPostComments(String postId) async {
    final response = await _apiClient.get(
      path: 'post/v1/post/$postId/comment/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> addPostComment(String postId, String text) async {
    final response = await _apiClient.post(
      path: 'post/v1/post/$postId/comment/',
      data: {'text': text},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deletePostComment(String postId, String commentId) async {
    final response = await _apiClient.delete(
      path: 'post/v1/post/$postId/comment/$commentId/delete/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> likePostComment(String commentId, String liked) async {
    final response = await _apiClient.post(
      path: 'post/v1/post/comment/$commentId/like/',
      data: {'type': liked},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> dislikePostComment(String commentId) async {
    final response = await _apiClient.delete(
      path: 'post/v1/post/comment/$commentId/like/',
    );
    return response.data;
  }
}
