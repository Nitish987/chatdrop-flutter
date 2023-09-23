import 'package:json_annotation/json_annotation.dart';

part 'hashtag_model.g.dart';

@JsonSerializable()
class HashtagModel {
  String? type;
  String? tag;

  HashtagModel({this.type, this.tag});

  factory HashtagModel.fromJson(Map<String, dynamic> json) => _$HashtagModelFromJson(json);

  Map<String, dynamic> toJson() => _$HashtagModelToJson(this);
}