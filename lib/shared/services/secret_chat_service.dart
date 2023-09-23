import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/repository/secret_chat_channel_repo.dart';
import 'package:chatdrop/shared/repository/secretchat_repo.dart';
import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';

class SecretChatService {
  final SecretChatRepository _chatRepository = SecretChatRepository.instance;

  /// create chat channel repository service instance
  static Future<SecretChatChannelRepository> getChannelInstance(String uid) async {
    final channel = SecretChatChannelRepository();
    await channel.create(uid);
    return channel;
  }

  /// checks whether user can chat with friend or not
  Future<bool> canChat(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _chatRepository.canChat(uid),
      );
      if (response.success) {
        return response.data!['can_chat'] as bool;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// sends message using http
  Future<PreKeyBundleModel?> sendMessage(String uid, SecretMessageModel message) async {
    try {
      final response = ResponseCollector.collect(
        await _chatRepository.sendMessage(uid, message.toJson()),
      );
      if (response.success) {
        final result = PreKeyBundleModel.fromJson(response.data?['prekey_bundle'] as Map<String, dynamic>);
        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// read message signal using http
  Future<bool> readMessage(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _chatRepository.messageReadSignal(uid),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// deletes message signal using http
  Future<bool?> deleteMessage(String uid, int messageId) async {
    try {
      final response = ResponseCollector.collect(
        await _chatRepository.messageDeleteSignal(uid, messageId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}

