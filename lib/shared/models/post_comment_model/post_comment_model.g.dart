// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentModel _$PostCommentModelFromJson(Map<String, dynamic> json) =>
    PostCommentModel(
      id: json['id'] as int?,
      postId: json['post_id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      text: json['text'] as String?,
      likesCount: json['likes_count'] as int?,
      commentedOn: json['commented_on'] as String?,
      liked: json['liked'] as String?,
    );

Map<String, dynamic> _$PostCommentModelToJson(PostCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user': instance.user,
      'text': instance.text,
      'likes_count': instance.likesCount,
      'commented_on': instance.commentedOn,
      'liked': instance.liked,
    };
