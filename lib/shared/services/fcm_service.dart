import 'dart:convert';

import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/message_model/secret_message_model.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';
import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:chatdrop/shared/services/secret_chat_message_service.dart';
import 'package:chatdrop/shared/services/push_notification_service.dart';
import 'package:chatdrop/shared/services/signal_protocol_service.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class FCMessagingService {
  /// validates whether the chat page is opened with given uid as arguments
  static bool _isValidRouteToHandleSecretChatMessages(CurrentRoute currentRoute, String uid) {
    return currentRoute.name != Routes.secretChat || (currentRoute.name == Routes.secretChat && currentRoute.arguments!['user'].uid != uid);
  }

  /// validates whether the chat page is opened with given uid as arguments
  static bool _isValidRouteToHandleNormalChatMessages(CurrentRoute currentRoute, String uid) {
    return currentRoute.name != Routes.normalChat || (currentRoute.name == Routes.normalChat && currentRoute.arguments!['user'].uid != uid);
  }

  /// fcm process in foreground
  static Future<void> processInForeground(RemoteMessage remoteMessage, CurrentRoute currentRoute) async {
    Map<String, dynamic> data = remoteMessage.data;
    NotificationModel notification = NotificationModel.fromJson(jsonDecode(data['content']) as Map<String, dynamic>);
    if (notification.type == 'SECRET_CHAT_MESSAGE' && _isValidRouteToHandleSecretChatMessages(currentRoute, notification.user!.uid!)) {
      _handleSecretChatMessages(notification, data);
    }
    if (notification.type == 'NORMAL_CHAT_MESSAGE' && _isValidRouteToHandleNormalChatMessages(currentRoute, notification.user!.uid!)) {
      _handleNormalChatMessages(notification, data);
    }
  }

  /// fcm process in background
  static Future<void> processInBackground(RemoteMessage remoteMessage) async {
    Map<String, dynamic> data = remoteMessage.data;
    NotificationModel notification = NotificationModel.fromJson(jsonDecode(data['content']) as Map<String, dynamic>);
    if(notification.type == 'SECRET_CHAT_MESSAGE') {
      UserService.loadAuthenticationData(onFinish: () {
        UserService.loadKeysStoresSync(onFinish: () {
          _handleSecretChatMessages(notification, data);
        });
      });
    }
    if (notification.type == 'NORMAL_CHAT_MESSAGE') {
      _handleNormalChatMessages(notification, data);
    }
  }

  /// handles chat messages only if notified
  static Future<void> _handleSecretChatMessages(NotificationModel notificationModel, Map<String, dynamic> data) async {
    Map<String, dynamic> extras = jsonDecode(data['extras']);
    SecretMessageModel messageModel = SecretMessageModel.fromJson(extras['message'] as Map<String, dynamic>);

    // initializing chat message service
    SecretChatMessageService chatMessageService = SecretChatMessageService();
    await chatMessageService.init();

    if(messageModel.messageType == 'NEW') {
      // decrypting message
      try {
        SignalProtocolService protocolService = await SignalProtocolService.init(notificationModel.user!.uid!);
        messageModel.content = await protocolService.decryptMessage(
          messageModel.senderPreKeyBundle!,
          messageModel.content!,
        );
      } catch(e) {
        messageModel.isInterrupted = true;
      }

      // deleting used pre-key from store
      await UserService.deletePreKeyFromStore(messageModel.receiverPreKeyId!);

      // storing message in local storage
      messageModel.chatWith = notificationModel.user!.uid!;
      await chatMessageService.storeMessage(notificationModel.user!, messageModel);

      // notify user
      if(messageModel.contentType == 'IMAGE') {
        PushNotificationService.push(notificationModel.id!, notificationModel.subject!, 'Photo');
      } else if (messageModel.contentType == 'VIDEO') {
        PushNotificationService.push(notificationModel.id!, notificationModel.subject!, 'Video');
      } else {
        if (messageModel.isInterrupted!) {
          PushNotificationService.push(notificationModel.id!, notificationModel.subject!, 'sends you a message');
        } else {
          SecretMessageContentModel messageContentModel = SecretMessageContentModel.fromJson(jsonDecode(messageModel.content!));
          PushNotificationService.push(notificationModel.id!, notificationModel.subject!, messageContentModel.text!);
        }
      }

      // checking if server is having pre-keys requirement
      _handlePreKeysRequirement(extras['is_prekeys_required'] as bool);

    } else if (messageModel.messageType == 'DEL') {
      // deleting message from local storage
      await chatMessageService.deleteMessageTemporary(messageModel.id!, notificationModel.user!.uid!);
    } else if (messageModel.messageType == 'READ') {
      // reading all messages
      chatMessageService.setIsReadTrue(notificationModel.user!.uid!);
    }

    // closing chat message service
    await chatMessageService.close();
  }

  static void _handlePreKeysRequirement(bool isPreKeysRequired) async {
    if (isPreKeysRequired) {
      AuthService service = AuthService();
      await service.postPreKeyBundleModel();
    }
  }

  static void _handleNormalChatMessages(NotificationModel notification, Map<String, dynamic> data) async {
    PushNotificationService.push(notification.id!, notification.subject!, notification.body!);
  }
}