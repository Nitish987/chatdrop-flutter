import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/modules/privacy/data/repository/privacy_repo.dart';

import '../../../../infra/utilities/response.dart';

class PrivacyService {
  final PrivacyRepository _privacyRepository = PrivacyRepository.instance;

  /// fetches blocked user
  Future<List<UserModel>?> fetchBlockUserList() async {
    try {
      final response = ResponseCollector.collect(await _privacyRepository.getBlockUserList());
      if (response.success) {
        List<dynamic> result = response.data?['blocked_users'];
        List<UserModel> blockedUsers = result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return blockedUsers;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// block user
  Future<bool> blockUser(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _privacyRepository.blockUser(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// unblock user
  Future<bool> unblockUser(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _privacyRepository.unblockUser(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// report user
  Future<bool> reportUser(String uid, String message) async {
    try {
      final response = ResponseCollector.collect(
        await _privacyRepository.reportUser(uid, message),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}