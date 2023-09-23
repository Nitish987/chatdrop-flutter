// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendProfileModel _$FriendProfileModelFromJson(Map<String, dynamic> json) =>
    FriendProfileModel(
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      profilePhotos: (json['profile_photos'] as List<dynamic>?)
          ?.map((e) => ProfilePhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileCoverPhotos: (json['profile_cover_photos'] as List<dynamic>?)
          ?.map(
              (e) => ProfileCoverPhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFriend: json['is_friend'] as bool?,
      isFriendRequested: json['is_friend_requested'] as bool?,
      friendRequestId: json['friend_request_id'] as int?,
      isFollowing: json['is_following'] as bool?,
      isFollowRequested: json['is_follow_requested'] as bool?,
      followRequestId: json['follow_request_id'] as int?,
      isBlocked: json['is_blocked'] as bool?,
    );

Map<String, dynamic> _$FriendProfileModelToJson(FriendProfileModel instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'profile_photos': instance.profilePhotos,
      'profile_cover_photos': instance.profileCoverPhotos,
      'is_friend': instance.isFriend,
      'is_friend_requested': instance.isFriendRequested,
      'friend_request_id': instance.friendRequestId,
      'is_following': instance.isFollowing,
      'is_follow_requested': instance.isFollowRequested,
      'follow_request_id': instance.followRequestId,
      'is_blocked': instance.isBlocked,
    };
