// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReelModel _$ReelModelFromJson(Map<String, dynamic> json) => ReelModel(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      type: json['type'] as String?,
      visibility: json['visibility'] as String?,
      postedOn: json['posted_on'] as String?,
      containsHashtags: json['contains_hashtags'] as bool?,
      isFollowing: json['is_following'] as bool? ?? false,
      likesCount: json['likes_count'] as int?,
      commentsCount: json['comments_count'] as int?,
      text: json['text'] as String?,
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => HashtagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      video: json['video'] == null
          ? null
          : ReelVideoModel.fromJson(json['video'] as Map<String, dynamic>),
      liked: json['liked'] as String?,
      authUser: json['auth_user'] == null
          ? null
          : UserModel.fromJson(json['auth_user'] as Map<String, dynamic>),
      isDeleted: json['is_deleted'] as bool? ?? false,
    )..viewsCount = json['views_count'] as int?;

Map<String, dynamic> _$ReelModelToJson(ReelModel instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'type': instance.type,
      'visibility': instance.visibility,
      'posted_on': instance.postedOn,
      'contains_hashtags': instance.containsHashtags,
      'is_following': instance.isFollowing,
      'views_count': instance.viewsCount,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'text': instance.text,
      'hashtags': instance.hashtags,
      'video': instance.video,
      'liked': instance.liked,
      'auth_user': instance.authUser,
      'is_deleted': instance.isDeleted,
    };

ReelVideoModel _$ReelVideoModelFromJson(Map<String, dynamic> json) =>
    ReelVideoModel(
      url: json['url'] as String?,
      thumbnail: json['thumbnail'] as String?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      audio: json['audio'] == null
          ? null
          : AudioModel.fromJson(json['audio'] as Map<String, dynamic>),
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReelVideoModelToJson(ReelVideoModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'thumbnail': instance.thumbnail,
      'labels': instance.labels,
      'audio': instance.audio,
      'aspect_ratio': instance.aspectRatio,
    };
