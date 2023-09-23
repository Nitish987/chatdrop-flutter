import 'package:json_annotation/json_annotation.dart';

part 'profile_cover_photo_model.g.dart';

@JsonSerializable()
class ProfileCoverPhotoModel {
  int? id;
  String? cover;

  ProfileCoverPhotoModel({this.id, this.cover});

  factory ProfileCoverPhotoModel.fromJson(Map<String, dynamic> json) => _$ProfileCoverPhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileCoverPhotoModelToJson(this);
}