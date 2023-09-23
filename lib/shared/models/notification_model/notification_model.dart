import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  int? id;
  @JsonKey(name: 'from_user')
  UserModel? user;
  String? subject;
  String? body;
  String? type;
  String? refer;
  @JsonKey(name: 'refer_content')
  Map<String, dynamic>? referContent;
  @JsonKey(name: 'is_read')
  bool? isRead;
  String? time;

  NotificationModel({
    this.id,
    this.user,
    this.subject,
    this.body,
    this.type,
    this.refer,
    this.referContent,
    this.isRead,
    this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}