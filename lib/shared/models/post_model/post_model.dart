import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../hashtag_model/hashtag_model.dart';
import '../user_model/user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String? id;
  UserModel? user;
  String? type;
  String? visibility;
  @JsonKey(name: 'content_type')
  String? contentType;
  @JsonKey(name: 'posted_on')
  String? postedOn;
  @JsonKey(name: 'contains_hashtags')
  bool? containsHashtags;
  @JsonKey(name: 'likes_count')
  int? likesCount;
  @JsonKey(name: 'comments_count')
  int? commentsCount;
  String? text;
  List<HashtagModel>? hashtags;
  PostVideoModel? video;
  List<PostPhotoModel>? photos;
  String? liked;
  @JsonKey(name: 'auth_user')
  UserModel? authUser;
  @JsonKey(name: 'is_deleted')
  bool? isDeleted;

  PostModel({
    this.id,
    this.user,
    this.type,
    this.visibility,
    this.contentType,
    this.postedOn,
    this.containsHashtags,
    this.likesCount,
    this.commentsCount,
    this.text,
    this.hashtags,
    this.video,
    this.photos,
    this.liked,
    this.authUser,
    this.isDeleted = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}


@JsonSerializable()
class PostPhotoModel {
  String? url;
  @JsonKey(name: 'aspect_ratio')
  double? aspectRatio;
  List<String>? labels;

  PostPhotoModel({this.url, this.aspectRatio, this.labels});

  factory PostPhotoModel.fromJson(Map<String, dynamic> json) => _$PostPhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostPhotoModelToJson(this);
}

@JsonSerializable()
class PostVideoModel {
  String? url;
  @JsonKey(name: 'aspect_ratio')
  double? aspectRatio;
  String? thumbnail;
  List<String>? labels;

  PostVideoModel({this.url, this.aspectRatio, this.thumbnail, this.labels});

  factory PostVideoModel.fromJson(Map<String, dynamic> json) => _$PostVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostVideoModelToJson(this);
}
