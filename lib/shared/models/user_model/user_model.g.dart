// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      username: json['username'] as String?,
      gender: json['gender'] as String?,
      message: json['message'] as String?,
      chatroom: json['chatroom'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'photo': instance.photo,
      'username': instance.username,
      'gender': instance.gender,
      'message': instance.message,
      'chatroom': instance.chatroom,
    };
