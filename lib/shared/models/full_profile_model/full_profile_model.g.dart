// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullProfileModel _$FullProfileModelFromJson(Map<String, dynamic> json) =>
    FullProfileModel(
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
    );

Map<String, dynamic> _$FullProfileModelToJson(FullProfileModel instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'profile_photos': instance.profilePhotos,
      'profile_cover_photos': instance.profileCoverPhotos,
    };
