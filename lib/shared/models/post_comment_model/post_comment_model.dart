import 'package:json_annotation/json_annotation.dart';

import '../user_model/user_model.dart';

part 'post_comment_model.g.dart';

@JsonSerializable()
class PostCommentModel {
  int? id;
  @JsonKey(name: 'post_id')
  String? postId;
  UserModel? user;
  String? text;
  @JsonKey(name: 'likes_count')
  int? likesCount;
  @JsonKey(name: 'commented_on')
  String? commentedOn;
  String? liked;

  PostCommentModel(
      {this.id,
        this.postId,
        this.user,
        this.text,
        this.likesCount,
        this.commentedOn,
        this.liked});

  factory PostCommentModel.fromJson(Map<String, dynamic> json) => _$PostCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentModelToJson(this);
}
