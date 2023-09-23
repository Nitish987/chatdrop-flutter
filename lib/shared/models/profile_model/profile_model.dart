import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  String? uid;
  String? name;
  String? username;
  String? photo;
  @JsonKey(name: 'cover_photo')
  String? coverPhoto;
  String? gender;
  String? message;
  String? bio;
  String? interest;
  String? website;
  String? location;
  @JsonKey(name: 'post_count')
  int? postCount;
  @JsonKey(name: 'follower_count')
  int? followerCount;
  @JsonKey(name: 'following_count')
  int? followingCount;
  @JsonKey(name: 'reel_count')
  int? reelCount;
  ProfileSettingsModel? settings;

  ProfileModel({
    this.uid,
    this.name,
    this.username,
    this.photo,
    this.coverPhoto,
    this.gender,
    this.message,
    this.bio,
    this.interest,
    this.website,
    this.location,
    this.postCount,
    this.followerCount,
    this.followingCount,
    this.reelCount,
    this.settings,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class ProfileSettingsModel {
  @JsonKey(name: 'is_profile_private')
  bool? isProfilePrivate;
  @JsonKey(name: 'default_post_visibility')
  String? defaultPostVisibility;
  @JsonKey(name: 'default_reel_visibility')
  String? defaultReelVisibility;
  @JsonKey(name: 'allow_chatgpt_info_access')
  bool? allowChatGptInfoAccess;

  ProfileSettingsModel({
    this.isProfilePrivate,
    this.defaultPostVisibility,
    this.defaultReelVisibility,
    this.allowChatGptInfoAccess,
  });

  factory ProfileSettingsModel.fromJson(Map<String, dynamic> json) => _$ProfileSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileSettingsModelToJson(this);
}