// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReelCommentModel _$ReelCommentModelFromJson(Map<String, dynamic> json) =>
    ReelCommentModel(
      id: json['id'] as int?,
      reelId: json['reel_id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      text: json['text'] as String?,
      likesCount: json['likes_count'] as int?,
      commentedOn: json['commented_on'] as String?,
      liked: json['liked'] as String?,
    );

Map<String, dynamic> _$ReelCommentModelToJson(ReelCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reel_id': instance.reelId,
      'user': instance.user,
      'text': instance.text,
      'likes_count': instance.likesCount,
      'commented_on': instance.commentedOn,
      'liked': instance.liked,
    };
