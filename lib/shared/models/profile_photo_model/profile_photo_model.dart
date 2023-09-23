import 'package:json_annotation/json_annotation.dart';

part 'profile_photo_model.g.dart';

@JsonSerializable()
class ProfilePhotoModel {
  int? id;
  String? photo;

  ProfilePhotoModel({this.id, this.photo});

  factory ProfilePhotoModel.fromJson(Map<String, dynamic> json) => _$ProfilePhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilePhotoModelToJson(this);
}