import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/repository/secret_chat_message_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/friend_profile_model/friend_profile_model.dart';
import '../repository/friend_repo.dart';

class FriendService {
  final FriendRepository _friendRepository = FriendRepository.instance;
  final SecretChatMessageRepository _chatMessageRepository = SecretChatMessageRepository();

  /// fetches friend (user) profile
  Future<FriendProfileModel?> fetchProfile(String uid) async {
    try {
      final response =
          ResponseCollector.collect(await _friendRepository.getProfile(uid));
      if (response.success) {
        FriendProfileModel model = FriendProfileModel.fromJson(response.data!);
        return model;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// sends friend request
  Future<bool> sendFriendRequest(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.sendFriendRequest(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// unfriend user
  Future<bool> unfriend(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.unfriend(uid),
      );
      // deleting recent chats if user gets unfriend
      if(response.success) {
        await _chatMessageRepository.init();
        await _chatMessageRepository.deleteRecentFully(uid);
        await _chatMessageRepository.close();
      }
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// accepts friend request
  Future<bool> acceptRequest(int requestId) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.acceptRequest(requestId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// list all friends
  Future<List<UserModel>?> listFriends(String uid, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.listFriends(uid, page: page),
      );
      if (response.success) {
        List<dynamic> results = response.data?['friends'];
        List<UserModel> friends = results.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return friends;
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  /// list my all friends
  Future<List<UserModel>?> listMyFriends({int page = 1}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return listFriends(uid, page: page);
  }


  /// Check whether the user is friend or not
  Future<bool> isFriend(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.checkFriend(uid),
      );
      if (response.success) {
        return response.data!['is_friend'] as bool;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// sends follow request
  Future<bool> sendFollowRequest(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.sendFollowRequest(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// accept follow request
  Future<bool> acceptFollowRequest(int requestId) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.acceptFollowRequest(requestId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// unfollow user
  Future<bool> unfollow(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _friendRepository.unfollow(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
