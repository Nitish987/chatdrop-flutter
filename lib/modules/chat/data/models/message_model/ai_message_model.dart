import 'package:json_annotation/json_annotation.dart';

part 'ai_message_model.g.dart';

@JsonSerializable()
class AiMessageModel {
  int? id;
  @JsonKey(name: 'sender_uid')
  String? senderUid;
  @JsonKey(name: 'content_type')
  String? contentType;
  String? content;
  @JsonKey(name: 'is_selected')
  bool? isSelected;
  int? time;

  AiMessageModel({
    required this.id,
    required this.senderUid,
    required this.contentType,
    this.content,
    this.isSelected = false,
    required this.time,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) => _$AiMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiMessageModelToJson(this);

  AiMessageModel copy() {
    return AiMessageModel(
        id: id,
        senderUid: senderUid,
        contentType: contentType,
        content: content,
        isSelected: isSelected,
        time: time,
    );
  }
}