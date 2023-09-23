import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:dio/dio.dart';

// User Profile Repository
class ProfileRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = ProfileRepository._();

  ProfileRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final response = await _apiClient.get(
      path: 'account/v1/profile/${UserService.authHeaders['uid']}/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> updateProfile(
      {required String message,
      required String bio,
      required String interest,
      required String location,
      required String website}) async {
    final response = await _apiClient.put(
      path: 'account/v1/profile/${UserService.authHeaders['uid']}/',
      data: {
        'message': message,
        'bio': bio,
        'interest': interest,
        'website': website,
        'location': location
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> updateProfilePhoto(String imagePath) async {
    final response = await _apiClient.multiPartPut(
        path: 'account/v1/profile/${UserService.authHeaders['uid']}/photo/update/',
        data: {
          'photo': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        });
    return response.data;
  }

  Future<Map<String, dynamic>?> switchProfilePhoto(int id) async {
    final response = await _apiClient.patch(
      path: 'account/v1/profile/${UserService.authHeaders['uid']}/photo/switch/$id/',
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteProfilePhoto(int id) async {
    final response = await _apiClient.delete(
        path: 'account/v1/profile/${UserService.authHeaders['uid']}/photo/switch/$id/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> updateProfileCoverPhoto(
      String imagePath) async {
    final response = await _apiClient.multiPartPut(
        path: 'account/v1/profile/${UserService.authHeaders['uid']}/cover/update/',
        data: {
          'cover_photo': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        });
    return response.data;
  }

  Future<Map<String, dynamic>?> switchProfileCoverPhoto(int id) async {
    final response = await _apiClient.patch(
      path: 'account/v1/profile/${UserService.authHeaders['uid']}/cover/switch/$id/',
      data: {},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> deleteProfileCoverPhoto(int id) async {
    final response = await _apiClient.delete(
        path: 'account/v1/profile/${UserService.authHeaders['uid']}/cover/switch/$id/',
    );
    return response.data;
  }
}
