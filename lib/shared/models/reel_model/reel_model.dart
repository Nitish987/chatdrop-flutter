import 'dart:convert';

import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../hashtag_model/hashtag_model.dart';
import '../user_model/user_model.dart';

part 'reel_model.g.dart';

@JsonSerializable()
class ReelModel {
  String? id;
  UserModel? user;
  String? type;
  String? visibility;
  @JsonKey(name: 'posted_on')
  String? postedOn;
  @JsonKey(name: 'contains_hashtags')
  bool? containsHashtags;
  @JsonKey(name: 'is_following')
  bool? isFollowing;
  @JsonKey(name: 'views_count')
  int? viewsCount;
  @JsonKey(name: 'likes_count')
  int? likesCount;
  @JsonKey(name: 'comments_count')
  int? commentsCount;
  String? text;
  List<HashtagModel>? hashtags;
  ReelVideoModel? video;
  String? liked;
  @JsonKey(name: 'auth_user')
  UserModel? authUser;
  @JsonKey(name: 'is_deleted')
  bool? isDeleted;

  ReelModel({
    this.id,
    this.user,
    this.type,
    this.visibility,
    this.postedOn,
    this.containsHashtags,
    this.isFollowing = false,
    this.likesCount,
    this.commentsCount,
    this.text,
    this.hashtags,
    this.video,
    this.liked,
    this.authUser,
    this.isDeleted = false,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) => _$ReelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReelModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}


@JsonSerializable()
class ReelVideoModel {
  String? url;
  String? thumbnail;
  List<String>? labels;
  AudioModel? audio;
  @JsonKey(name: 'aspect_ratio')
  double? aspectRatio;

  ReelVideoModel({this.url, this.thumbnail, this.labels, this.audio, this.aspectRatio});

  factory ReelVideoModel.fromJson(Map<String, dynamic> json) => _$ReelVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReelVideoModelToJson(this);
}
