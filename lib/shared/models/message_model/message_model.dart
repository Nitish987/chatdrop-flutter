import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? id;
  @JsonKey(name: 'chat_with')
  String? chatWith;
  @JsonKey(name: 'sender_uid')
  String? senderUid;
  String? refer;
  @JsonKey(name: 'content_type')
  String? contentType;
  String? content;
  @JsonKey(name: 'is_delivered')
  bool? isDelivered;
  @JsonKey(name: 'is_read')
  bool? isRead;
  @JsonKey(name: 'is_deleted')
  bool? isDeleted;
  @JsonKey(name: 'is_selected')
  bool? isSelected;
  int? time;

  MessageModel({
    this.id,
    this.chatWith,
    this.senderUid,
    this.refer,
    this.contentType,
    this.content,
    this.isDelivered = true,
    this.isRead = false,
    this.isDeleted = false,
    this.isSelected = false,
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}