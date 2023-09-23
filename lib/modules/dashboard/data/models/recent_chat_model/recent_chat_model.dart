import 'package:chatdrop/shared/models/message_model/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recent_chat_model.g.dart';

@JsonSerializable()
class RecentChatModel {
  String? uid;
  String? photo;
  String? name;
  MessageModel? message;
  String? gender;
  int? time;
  String? chatroom;

  RecentChatModel({
    this.uid,
    this.photo,
    this.name,
    this.message,
    this.gender,
    this.time,
    this.chatroom,
  });

  factory RecentChatModel.fromJson(Map<String, dynamic> json) => _$RecentChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentChatModelToJson(this);
}