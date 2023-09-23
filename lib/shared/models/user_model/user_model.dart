import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? uid;
  String? name;
  String? photo;
  String? username;
  String? gender;
  String? message;
  String? chatroom;

  UserModel({
    this.uid,
    this.name,
    this.photo,
    this.username,
    this.gender,
    this.message,
    this.chatroom,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
