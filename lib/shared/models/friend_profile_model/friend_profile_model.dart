import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_profile_model.g.dart';

@JsonSerializable()
class FriendProfileModel {
  ProfileModel? profile;
  @JsonKey(name: 'profile_photos')
  List<ProfilePhotoModel>? profilePhotos;
  @JsonKey(name: 'profile_cover_photos')
  List<ProfileCoverPhotoModel>? profileCoverPhotos;
  @JsonKey(name: 'is_friend')
  bool? isFriend;
  @JsonKey(name: 'is_friend_requested')
  bool? isFriendRequested;
  @JsonKey(name: 'friend_request_id')
  int? friendRequestId;
  @JsonKey(name: 'is_following')
  bool? isFollowing;
  @JsonKey(name: 'is_follow_requested')
  bool? isFollowRequested;
  @JsonKey(name: 'follow_request_id')
  int? followRequestId;
  @JsonKey(name: 'is_blocked')
  bool? isBlocked;

  FriendProfileModel({this.profile,
    this.profilePhotos,
    this.profileCoverPhotos,
    this.isFriend,
    this.isFriendRequested,
    this.friendRequestId,
    this.isFollowing,
    this.isFollowRequested,
    this.followRequestId,
    this.isBlocked,
  });

  factory FriendProfileModel.fromJson(Map<String, dynamic> json) => _$FriendProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendProfileModelToJson(this);
}
