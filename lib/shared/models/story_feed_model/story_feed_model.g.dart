// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryFeedModel _$StoryFeedModelFromJson(Map<String, dynamic> json) =>
    StoryFeedModel(
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryFeedModelToJson(StoryFeedModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'stories': instance.stories,
    };
