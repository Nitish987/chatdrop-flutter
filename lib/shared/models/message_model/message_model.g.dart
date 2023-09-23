// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String?,
      chatWith: json['chat_with'] as String?,
      senderUid: json['sender_uid'] as String?,
      refer: json['refer'] as String?,
      contentType: json['content_type'] as String?,
      content: json['content'] as String?,
      isDelivered: json['is_delivered'] as bool? ?? true,
      isRead: json['is_read'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      isSelected: json['is_selected'] as bool? ?? false,
      time: json['time'] as int?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_with': instance.chatWith,
      'sender_uid': instance.senderUid,
      'refer': instance.refer,
      'content_type': instance.contentType,
      'content': instance.content,
      'is_delivered': instance.isDelivered,
      'is_read': instance.isRead,
      'is_deleted': instance.isDeleted,
      'is_selected': instance.isSelected,
      'time': instance.time,
    };
