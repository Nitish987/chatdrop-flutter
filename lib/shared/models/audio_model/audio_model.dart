import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_model.g.dart';

@JsonSerializable()
class AudioModel {
  int? id;
  String? name;
  String? filename;
  String? url;
  int? duration;
  @JsonKey(name: 'from_user')
  UserModel? user;

  AudioModel({this.id, this.name, this.filename, this.url, this.duration, this.user});

  factory AudioModel.fromJson(Map<String, dynamic> json) => _$AudioModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudioModelToJson(this);
}