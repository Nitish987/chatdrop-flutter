// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecretMessageModel _$SecretMessageModelFromJson(Map<String, dynamic> json) =>
    SecretMessageModel(
      id: json['id'] as int?,
      chatWith: json['chat_with'] as String?,
      senderUid: json['sender_uid'] as String?,
      messageType: json['message_type'] as String?,
      refer: json['refer'] as String?,
      contentType: json['content_type'] as String?,
      content: json['content'] as String?,
      isDelivered: json['is_delivered'] as bool? ?? false,
      isRead: json['is_read'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isInterrupted: json['is_interrupted'] as bool? ?? false,
      isSelected: json['is_selected'] as bool? ?? false,
      time: json['time'] as int?,
      receiverPreKeyId: json['receiver_prekey_id'] as int?,
      senderPreKeyBundle: json['sender_prekey_bundle'] == null
          ? null
          : PreKeyBundleModel.fromJson(
              json['sender_prekey_bundle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SecretMessageModelToJson(SecretMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_with': instance.chatWith,
      'sender_uid': instance.senderUid,
      'message_type': instance.messageType,
      'refer': instance.refer,
      'content_type': instance.contentType,
      'content': instance.content,
      'is_delivered': instance.isDelivered,
      'is_read': instance.isRead,
      'is_deleted': instance.isDeleted,
      'is_interrupted': instance.isInterrupted,
      'is_selected': instance.isSelected,
      'time': instance.time,
      'receiver_prekey_id': instance.receiverPreKeyId,
      'sender_prekey_bundle': instance.senderPreKeyBundle,
    };

SecretMessageContentModel _$SecretMessageContentModelFromJson(
        Map<String, dynamic> json) =>
    SecretMessageContentModel(
      text: json['text'] as String?,
      contentName: json['contentName'] as String?,
      content: json['content'] as String?,
      localContentPath: json['localContentPath'] as String?,
    );

Map<String, dynamic> _$SecretMessageContentModelToJson(
        SecretMessageContentModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'contentName': instance.contentName,
      'content': instance.content,
      'localContentPath': instance.localContentPath,
    };

RecentSecretMessageModel _$RecentSecretMessageModelFromJson(
        Map<String, dynamic> json) =>
    RecentSecretMessageModel(
      chatWith: json['chat_with'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      gender: json['gender'] as String?,
      messageId: json['message_id'] as int?,
    );

Map<String, dynamic> _$RecentSecretMessageModelToJson(
        RecentSecretMessageModel instance) =>
    <String, dynamic>{
      'chat_with': instance.chatWith,
      'name': instance.name,
      'photo': instance.photo,
      'gender': instance.gender,
      'message_id': instance.messageId,
    };
