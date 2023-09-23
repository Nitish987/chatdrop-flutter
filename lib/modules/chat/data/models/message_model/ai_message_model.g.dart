// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiMessageModel _$AiMessageModelFromJson(Map<String, dynamic> json) =>
    AiMessageModel(
      id: json['id'] as int?,
      senderUid: json['sender_uid'] as String?,
      contentType: json['content_type'] as String?,
      content: json['content'] as String?,
      isSelected: json['is_selected'] as bool? ?? false,
      time: json['time'] as int?,
    );

Map<String, dynamic> _$AiMessageModelToJson(AiMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_uid': instance.senderUid,
      'content_type': instance.contentType,
      'content': instance.content,
      'is_selected': instance.isSelected,
      'time': instance.time,
    };
