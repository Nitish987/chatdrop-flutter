import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_feed_model.g.dart';

@JsonSerializable()
class StoryFeedModel {
  UserModel? user;
  List<StoryModel>? stories;

  StoryFeedModel({this.user, this.stories});

  factory StoryFeedModel.fromJson(Map<String, dynamic> json) => _$StoryFeedModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryFeedModelToJson(this);
}