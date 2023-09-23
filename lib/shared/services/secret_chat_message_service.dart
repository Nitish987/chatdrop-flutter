import 'dart:convert';
import 'dart:io';

import 'package:chatdrop/infra/utilities/aes.dart';
import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/models/recent_secret_chat_model/recent_secret_chat_model.dart';
import 'package:chatdrop/shared/repository/secret_chat_message_repo.dart';
import 'package:chatdrop/settings/utilities/directory_settings.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SecretChatMessageService {
  final SecretChatMessageRepository _chatMessageRepository = SecretChatMessageRepository();

  Future<void> init() async {
    await _chatMessageRepository.init();
  }

  Future<SecretMessageModel> storeMessage(UserModel remoteUser, SecretMessageModel model) async {
    SecretMessageModel modelCopy = model.copy();

    if (!model.isInterrupted!) {
      // extracting message content
      SecretMessageContentModel messageContent = SecretMessageContentModel.fromJson(jsonDecode(model.content!));

      // saving message content files in temporary files
      if (model.contentType == 'IMAGE' || model.contentType == 'VIDEO') {
        String path = await DirectorySettings.tempMediaDirectoryPath;
        File file = File('$path/${messageContent.contentName}');
        file.writeAsBytesSync(base64ToBytes(messageContent.content!));
        messageContent.localContentPath = file.absolute.path;
        model.content = messageContent.toString();
        modelCopy.content = messageContent.toString();
      }

      modelCopy.content = Aes256.encrypt(modelCopy.content!, UserService.encryptionKey);
    }

    // stores message
    await _chatMessageRepository.storeMessage(modelCopy);

    // recent chat with remote user
    await _chatMessageRepository.storeRecent(RecentSecretMessageModel(
      chatWith: model.chatWith!,
      name: remoteUser.name,
      photo: remoteUser.photo,
      gender: remoteUser.gender,
      messageId: model.id!,
    ));

    return model;
  }

  Future<List<SecretMessageModel>> retrieveMessages(String chatWith) async {
    List<SecretMessageModel> messages = await _chatMessageRepository.retrieveMessages(chatWith);
    messages = messages.map((model) {
      if (!model.isInterrupted!) {
        model.content = Aes256.decrypt(model.content!, UserService.encryptionKey);
      }
      return model;
    }).toList();
    return messages;
  }

  Future<SecretMessageModel?> retrieveMessage(int id, String chatWith) async {
    SecretMessageModel? model = await _chatMessageRepository.retrieveMessage(id, chatWith);
    if (model != null && !model.isInterrupted!) {
        model.content = Aes256.decrypt(model.content!, UserService.encryptionKey);
    }
    return model;
  }

  Future<List<RecentSecretChatModel>> retrieveRecentChats() async {
    List<RecentSecretMessageModel> recentMessages = await _chatMessageRepository.retrieveRecent();
    List<RecentSecretChatModel> recentChats = <RecentSecretChatModel>[];
    for(RecentSecretMessageModel recentMessage in recentMessages) {
      SecretMessageModel? message = await retrieveMessage(recentMessage.messageId!, recentMessage.chatWith!);
      if(message != null) {
        recentChats.add(RecentSecretChatModel(recentMessage, message));
      }
    }
    return recentChats;
  }

  Future<void> setIsReadTrue(String chatWith) async {
    await _chatMessageRepository.setIsReadTrue(chatWith);
  }

  Future<void> setIsInterruptedTrue(int id, String chatWith, SecretMessageModel model) async {
    SecretMessageModel modelCopy = model.copy();

    if (!model.isInterrupted!) {
      // extracting message content
      SecretMessageContentModel messageContent = SecretMessageContentModel.fromJson(jsonDecode(model.content!));

      // saving message content files in temporary files
      if (model.contentType == 'IMAGE' || model.contentType == 'VIDEO') {
        String path = await DirectorySettings.tempMediaDirectoryPath;
        File file = File('$path/${messageContent.contentName}');
        file.writeAsBytesSync(base64ToBytes(messageContent.content!));
        messageContent.localContentPath = file.absolute.path;
        model.content = messageContent.toString();
        modelCopy.content = messageContent.toString();
      }

      modelCopy.content = Aes256.encrypt(modelCopy.content!, UserService.encryptionKey);
    }

    await _chatMessageRepository.setIsInterruptedFalse(id, chatWith, modelCopy.content!);
  }

  Future<void> deleteMessageTemporary(int id, String chatWith) async {
    await _chatMessageRepository.deleteMessage(DeleteType.temporary, id, chatWith);
    await _chatMessageRepository.deleteRecent(chatWith, id);
  }

  Future<void> deleteMessagePermanent(int id, String chatWith) async {
    await _chatMessageRepository.deleteMessage(DeleteType.permanent, id, chatWith);
    await _chatMessageRepository.deleteRecent(chatWith, id);
  }

  Future<void> deleteMessagesTemporary(String chatWith) async {
    await _chatMessageRepository.deleteMessages(DeleteType.temporary, chatWith);
  }

  Future<void> deleteMessagesPermanent(String chatWith) async {
    await _chatMessageRepository.deleteMessages(DeleteType.permanent, chatWith);
  }

  Future<void> deleteFromRecent(String chatWith) async {
    await _chatMessageRepository.deleteRecentFully(chatWith);
  }

  Future<void> close() async {
    await _chatMessageRepository.close();
  }
}