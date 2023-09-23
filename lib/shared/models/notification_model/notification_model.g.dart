// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as int?,
      user: json['from_user'] == null
          ? null
          : UserModel.fromJson(json['from_user'] as Map<String, dynamic>),
      subject: json['subject'] as String?,
      body: json['body'] as String?,
      type: json['type'] as String?,
      refer: json['refer'] as String?,
      referContent: json['refer_content'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool?,
      time: json['time'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_user': instance.user,
      'subject': instance.subject,
      'body': instance.body,
      'type': instance.type,
      'refer': instance.refer,
      'refer_content': instance.referContent,
      'is_read': instance.isRead,
      'time': instance.time,
    };
