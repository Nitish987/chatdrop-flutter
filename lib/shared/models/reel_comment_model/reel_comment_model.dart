import 'package:json_annotation/json_annotation.dart';

import '../user_model/user_model.dart';

part 'reel_comment_model.g.dart';

@JsonSerializable()
class ReelCommentModel {
  int? id;
  @JsonKey(name: 'reel_id')
  String? reelId;
  UserModel? user;
  String? text;
  @JsonKey(name: 'likes_count')
  int? likesCount;
  @JsonKey(name: 'commented_on')
  String? commentedOn;
  String? liked;

  ReelCommentModel(
      {this.id,
        this.reelId,
        this.user,
        this.text,
        this.likesCount,
        this.commentedOn,
        this.liked});

  factory ReelCommentModel.fromJson(Map<String, dynamic> json) => _$ReelCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReelCommentModelToJson(this);
}
