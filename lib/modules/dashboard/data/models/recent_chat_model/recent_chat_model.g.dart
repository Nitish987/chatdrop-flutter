// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentChatModel _$RecentChatModelFromJson(Map<String, dynamic> json) =>
    RecentChatModel(
      uid: json['uid'] as String?,
      photo: json['photo'] as String?,
      name: json['name'] as String?,
      message: json['message'] == null
          ? null
          : MessageModel.fromJson(json['message'] as Map<String, dynamic>),
      gender: json['gender'] as String?,
      time: json['time'] as int?,
      chatroom: json['chatroom'] as String?,
    );

Map<String, dynamic> _$RecentChatModelToJson(RecentChatModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'photo': instance.photo,
      'name': instance.name,
      'message': instance.message,
      'gender': instance.gender,
      'time': instance.time,
      'chatroom': instance.chatroom,
    };
