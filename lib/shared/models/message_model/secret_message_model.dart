import 'dart:convert';

import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'secret_message_model.g.dart';

@JsonSerializable()
class SecretMessageModel {
  int? id;
  @JsonKey(name: 'chat_with')
  String? chatWith;
  @JsonKey(name: 'sender_uid')
  String? senderUid;
  @JsonKey(name: 'message_type')
  String? messageType;
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
  @JsonKey(name: 'is_interrupted')
  bool? isInterrupted;
  @JsonKey(name: 'is_selected')
  bool? isSelected;
  int? time;
  @JsonKey(name: 'receiver_prekey_id')
  int? receiverPreKeyId;
  @JsonKey(name: 'sender_prekey_bundle')
  PreKeyBundleModel? senderPreKeyBundle;

  SecretMessageModel({
    this.id,
    this.chatWith,
    this.senderUid,
    required this.messageType,
    this.refer,
    this.contentType,
    this.content,
    this.isDelivered = false,
    this.isRead = false,
    this.isDeleted = false,
    this.isInterrupted = false,
    this.isSelected = false,
    this.time,
    this.receiverPreKeyId,
    this.senderPreKeyBundle,
  });

  factory SecretMessageModel.fromJson(Map<String, dynamic> json) => _$SecretMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SecretMessageModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  SecretMessageModel copy() {
    return SecretMessageModel(
      id: id,
      chatWith: chatWith,
      senderUid: senderUid,
      messageType: messageType,
      refer: refer,
      contentType: contentType,
      content: content,
      isDelivered: isDelivered,
      isRead: isRead,
      isDeleted: isDeleted,
      isInterrupted: isInterrupted,
      time: time,
    );
  }
}

@JsonSerializable()
class SecretMessageContentModel {
  String? text;
  String? contentName;
  String? content;
  String? localContentPath;

  SecretMessageContentModel({this.text, this.contentName, this.content, this.localContentPath});

  factory SecretMessageContentModel.fromJson(Map<String, dynamic> json) => _$SecretMessageContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SecretMessageContentModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RecentSecretMessageModel {
  @JsonKey(name: 'chat_with')
  String? chatWith;
  String? name;
  String? photo;
  String? gender;
  @JsonKey(name: 'message_id')
  int? messageId;

  RecentSecretMessageModel({this.chatWith, this.name, this.photo, this.gender, this.messageId});

  factory RecentSecretMessageModel.fromJson(Map<String, dynamic> json) => _$RecentSecretMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentSecretMessageModelToJson(this);
}