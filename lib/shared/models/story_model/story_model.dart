import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  String? id;
  @JsonKey(name: 'content_type')
  String? contentType;
  String? content;
  String? text;
  @JsonKey(name: 'posted_on')
  String? postedOn;
  @JsonKey(name: 'likes_count')
  int? likesCount;

  StoryModel(
      {this.id,
        this.contentType,
        this.content,
        this.text,
        this.postedOn,
        this.likesCount});

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
