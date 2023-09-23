// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioModel _$AudioModelFromJson(Map<String, dynamic> json) => AudioModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      filename: json['filename'] as String?,
      url: json['url'] as String?,
      duration: json['duration'] as int?,
      user: json['from_user'] == null
          ? null
          : UserModel.fromJson(json['from_user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AudioModelToJson(AudioModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'filename': instance.filename,
      'url': instance.url,
      'duration': instance.duration,
      'from_user': instance.user,
    };
