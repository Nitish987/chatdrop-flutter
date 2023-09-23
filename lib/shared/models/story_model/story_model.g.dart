// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as String?,
      contentType: json['content_type'] as String?,
      content: json['content'] as String?,
      text: json['text'] as String?,
      postedOn: json['posted_on'] as String?,
      likesCount: json['likes_count'] as int?,
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content_type': instance.contentType,
      'content': instance.content,
      'text': instance.text,
      'posted_on': instance.postedOn,
      'likes_count': instance.likesCount,
    };
