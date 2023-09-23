// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      type: json['type'] as String?,
      visibility: json['visibility'] as String?,
      contentType: json['content_type'] as String?,
      postedOn: json['posted_on'] as String?,
      containsHashtags: json['contains_hashtags'] as bool?,
      likesCount: json['likes_count'] as int?,
      commentsCount: json['comments_count'] as int?,
      text: json['text'] as String?,
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => HashtagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      video: json['video'] == null
          ? null
          : PostVideoModel.fromJson(json['video'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PostPhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      liked: json['liked'] as String?,
      authUser: json['auth_user'] == null
          ? null
          : UserModel.fromJson(json['auth_user'] as Map<String, dynamic>),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'type': instance.type,
      'visibility': instance.visibility,
      'content_type': instance.contentType,
      'posted_on': instance.postedOn,
      'contains_hashtags': instance.containsHashtags,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'text': instance.text,
      'hashtags': instance.hashtags,
      'video': instance.video,
      'photos': instance.photos,
      'liked': instance.liked,
      'auth_user': instance.authUser,
      'is_deleted': instance.isDeleted,
    };

PostPhotoModel _$PostPhotoModelFromJson(Map<String, dynamic> json) =>
    PostPhotoModel(
      url: json['url'] as String?,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PostPhotoModelToJson(PostPhotoModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'aspect_ratio': instance.aspectRatio,
      'labels': instance.labels,
    };

PostVideoModel _$PostVideoModelFromJson(Map<String, dynamic> json) =>
    PostVideoModel(
      url: json['url'] as String?,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      thumbnail: json['thumbnail'] as String?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PostVideoModelToJson(PostVideoModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'aspect_ratio': instance.aspectRatio,
      'thumbnail': instance.thumbnail,
      'labels': instance.labels,
    };
