import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';

import '../../data/repository/fans_repo.dart';

class FansService {
  final FansRepository _fansRepository = FansRepository.instance;

  Future<List<UserModel>?> listFollowers(String uid, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _fansRepository.listFollowers(uid, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['followers'];
        List<UserModel> users = result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return users;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>?> listFollowings(String uid, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _fansRepository.listFollowings(uid, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['followings'];
        List<UserModel> users = result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return users;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}