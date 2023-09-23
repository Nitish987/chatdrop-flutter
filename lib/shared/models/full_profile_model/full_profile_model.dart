import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full_profile_model.g.dart';

@JsonSerializable()
class FullProfileModel {
  ProfileModel? profile;
  @JsonKey(name: 'profile_photos')
  List<ProfilePhotoModel>? profilePhotos;
  @JsonKey(name: 'profile_cover_photos')
  List<ProfileCoverPhotoModel>? profileCoverPhotos;

  FullProfileModel(
      {this.profile,
        this.profilePhotos,
        this.profileCoverPhotos});

  factory FullProfileModel.fromJson(Map<String, dynamic> json) => _$FullProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FullProfileModelToJson(this);
}