// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      photo: json['photo'] as String?,
      coverPhoto: json['cover_photo'] as String?,
      gender: json['gender'] as String?,
      message: json['message'] as String?,
      bio: json['bio'] as String?,
      interest: json['interest'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      postCount: json['post_count'] as int?,
      followerCount: json['follower_count'] as int?,
      followingCount: json['following_count'] as int?,
      reelCount: json['reel_count'] as int?,
      settings: json['settings'] == null
          ? null
          : ProfileSettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'username': instance.username,
      'photo': instance.photo,
      'cover_photo': instance.coverPhoto,
      'gender': instance.gender,
      'message': instance.message,
      'bio': instance.bio,
      'interest': instance.interest,
      'website': instance.website,
      'location': instance.location,
      'post_count': instance.postCount,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'reel_count': instance.reelCount,
      'settings': instance.settings,
    };

ProfileSettingsModel _$ProfileSettingsModelFromJson(
        Map<String, dynamic> json) =>
    ProfileSettingsModel(
      isProfilePrivate: json['is_profile_private'] as bool?,
      defaultPostVisibility: json['default_post_visibility'] as String?,
      defaultReelVisibility: json['default_reel_visibility'] as String?,
      allowChatGptInfoAccess: json['allow_chatgpt_info_access'] as bool?,
    );

Map<String, dynamic> _$ProfileSettingsModelToJson(
        ProfileSettingsModel instance) =>
    <String, dynamic>{
      'is_profile_private': instance.isProfilePrivate,
      'default_post_visibility': instance.defaultPostVisibility,
      'default_reel_visibility': instance.defaultReelVisibility,
      'allow_chatgpt_info_access': instance.allowChatGptInfoAccess,
    };
