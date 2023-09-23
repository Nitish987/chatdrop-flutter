import 'dart:async';
import 'dart:convert';
import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/repository/secret_chat_channel_repo.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:chatdrop/shared/services/secret_chat_message_service.dart';
import 'package:chatdrop/shared/services/secret_chat_service.dart';
import 'package:chatdrop/shared/services/signal_protocol_service.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// remote means the other user with whom you are chatting
class SecretChatController {
  late Stream<dynamic> _stream;
  late SecretChatChannelRepository _chatChannel;
  late bool isInitialized;
  late UserModel remoteUser;
  late String? senderUid;
  late PreKeyBundleModel? remotePreKeyBundleModel;
  late PreKeyBundleModel? senderPreKeyBundleModel;
  late SignalProtocolService _signalProtocolService;
  final SecretChatService _chatService = SecretChatService();
  final SecretChatMessageService _chatMessageService = SecretChatMessageService();
  final AuthService _authService = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  SecretChatController() {
    isInitialized = false;
  }

  /// initializing chat controller
  Future<void> init(UserModel remoteUser) async {
    this.remoteUser = remoteUser;
    UserService userService = await UserService.instance;
    senderUid = userService.getUserId();
    await _chatMessageService.init();
    _signalProtocolService = await SignalProtocolService.init(remoteUser.uid!);
    _chatChannel = await SecretChatService.getChannelInstance(remoteUser.uid!);
    _stream = _chatChannel.stream;
    remotePreKeyBundleModel = await _authService.getPreKeyBundleModel(remoteUser.uid!);
    if (remotePreKeyBundleModel != null) {
      isInitialized = true;
    }
  }

  /// listens for communication response
  void responseListener(Function onListen) {
    _stream.listen((event) async {
      final response = ResponseCollector.collect(jsonDecode(event) as Map<String, dynamic>);
      if (response.success) {
        SecretMessageModel message = SecretMessageModel.fromJson(response.data!);
        // checking whether the the message is from other user
        if (message.senderUid == remoteUser.uid && message.messageType == 'NEW') {
          // instant messaging reading
          message.isRead = true;

          try {
          // decrypting message
            message.content = await _signalProtocolService.decryptMessage(
              message.senderPreKeyBundle!,
              message.content!,
            );
          } catch (e) {
            message.isInterrupted = true;
          }
          // changing receivers new pre-key bundle model
          remotePreKeyBundleModel = message.senderPreKeyBundle;
          // deleting used pre-key from store
          await UserService.deletePreKeyFromStore(message.receiverPreKeyId!);
        } else if (message.senderUid == remoteUser.uid && message.messageType == 'INTERRUPT') {
          remotePreKeyBundleModel = message.senderPreKeyBundle;
        } else if (message.senderUid == remoteUser.uid && message.messageType == 'RECOVER') {
          try {
            // decrypting message
            message.content = await _signalProtocolService.decryptMessage(
              message.senderPreKeyBundle!,
              message.content!,
            );
          } catch (e) {
            message.isInterrupted = true;
          }

          // deleting used pre-key from store
          await UserService.deletePreKeyFromStore(message.receiverPreKeyId!);
        }
        onListen(message);
      }
    });
  }

  /// returns stream
  Stream<dynamic> get stream {
    return _stream;
  }

  /// changes the status - online, typing etc of current user
  void changeStatus(String status) {
    firestore.collection('status').doc(senderUid!).set({'status': status});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenStatusSignal() {
    return firestore.collection('status').doc(remoteUser.uid!).snapshots();
  }

  /// sends the message
  Future<void> send(SecretMessageModel message) async {
    if (isInitialized) {
      // attaching receiver pre-key id
      message.receiverPreKeyId = remotePreKeyBundleModel!.preKeys![0].id!;
      // encrypting message
      message.content = await _signalProtocolService.encryptMessage(remotePreKeyBundleModel!, message.content!);
      PreKeyBundleModel? result = await _chatService.sendMessage(
          remoteUser.uid!,
          message,
      );
      if(result != null) {
        remotePreKeyBundleModel = result;
      }
    }
  }

  /// sends the message read signal
  Future<void> sendMessageReadSignal() async {
    if(isInitialized) {
      await _chatService.readMessage(remoteUser.uid!);
    }
  }

  /// interrupted message signal
  void interruptedMessageSignal(int messageId) async {
    if(isInitialized) {
      await loadSenderPreKeyBundleModel();
      _chatChannel.send(SecretMessageModel(
        id: messageId,
        messageType: 'INTERRUPT',
        senderUid: senderUid,
        senderPreKeyBundle: senderPreKeyBundleModel,
      ));
    }
  }

  /// recover interrupted message
  void sendRecoveredInterruptedMessage(SecretMessageModel message) async {
    if(isInitialized) {
      await loadSenderPreKeyBundleModel();
      message.messageType = 'RECOVER';
      message.senderUid = senderUid!;
      // attaching receiver pre-key id
      message.receiverPreKeyId = remotePreKeyBundleModel!.preKeys![0].id!;
      // encrypting message
      message.content = await _signalProtocolService.encryptMessage(remotePreKeyBundleModel!, message.content!);
      message.senderPreKeyBundle = senderPreKeyBundleModel;
      _chatChannel.send(message);
    }
  }

  /// reads all messages
  void readAllMessages() async {
    await _chatMessageService.setIsReadTrue(remoteUser.uid!);
  }

  /// recover message in local storage
  void recoverMessageInLocalStorage(SecretMessageModel messageModel) async {
    await _chatMessageService.setIsInterruptedTrue(messageModel.id!, remoteUser.uid!, messageModel);
  }

  /// loads sender pre-key bundle model
  Future<void> loadSenderPreKeyBundleModel() async {
    senderPreKeyBundleModel = await UserService.getPreKeyBundleModel();
  }

  /// store messages in local storage
  Future<SecretMessageModel> storeMessageInLocalStorage(SecretMessageModel model) async {
    if(isInitialized) {
      model.chatWith = remoteUser.uid;
      SecretMessageModel storedMessage = await _chatMessageService.storeMessage(remoteUser, model);
      return storedMessage;
    }
    return model;
  }

  /// retrieve single message from local storage
  Future<SecretMessageModel?> retrieveSingleMessageFromLocalStorage(int id) async {
    return await _chatMessageService.retrieveMessage(id, remoteUser.uid!);
  }

  /// retrieve messages from local storage
  Future<List<SecretMessageModel>> retrieveMessagesFromLocalStorage() async {
    return await _chatMessageService.retrieveMessages(remoteUser.uid!);
  }

  /// delete message from local storage
  Future<void> deleteMessageFromLocalStorage(int id) async {
    if(isInitialized) {
      await _chatMessageService.deleteMessageTemporary(id, remoteUser.uid!);
    }
  }

  /// delete message from current user
  Future<void> deleteMessageFromMe(List<SecretMessageModel> messages) async {
    if(isInitialized) {
      for (SecretMessageModel message in messages) {
        if(message.isDeleted!) {
          await _chatMessageService.deleteMessagePermanent(message.id!, remoteUser.uid!);
        } else {
          await _chatMessageService.deleteMessageTemporary(message.id!, remoteUser.uid!);
        }
      }
    }
  }

  /// delete message from both user
  Future<void> deleteMessageFromEveryone(int id) async {
    if (isInitialized) {
      // sending delete message signal to communication channel
      await _chatService.deleteMessage(remoteUser.uid!, id);
      // deleting from local storage
      await deleteMessageFromLocalStorage(id);
    }
  }

  /// delete all chat messages from local storage
  Future<void> clearChats() async {
    if(isInitialized) {
      await _chatMessageService.deleteMessagesPermanent(remoteUser.uid!);
    }
  }

  /// delete from recent chats
  Future<void> deleteFromRecent() async {
    if(isInitialized) {
      await _chatMessageService.deleteFromRecent(remoteUser.uid!);
    }
  }

  /// closes the chatting connection
  void dispose() async {
    isInitialized = false;
    await _chatChannel.drop();
    await _chatMessageService.close();
  }
}