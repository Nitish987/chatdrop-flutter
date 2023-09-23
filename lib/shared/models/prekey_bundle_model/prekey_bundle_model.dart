import 'package:json_annotation/json_annotation.dart';

part 'prekey_bundle_model.g.dart';

@JsonSerializable()
class PreKeyBundleModel {
  @JsonKey(name: 'reg_id')
  int? registrationId;
  @JsonKey(name: 'device_id')
  int? deviceId;
  @JsonKey(name: 'prekeys')
  List<PreKeyModel>? preKeys;
  @JsonKey(name: 'signed_prekey')
  SignedPreKeyModel? signedPreKey;
  @JsonKey(name: 'identity_key')
  String? identityKey;

  PreKeyBundleModel({this.registrationId, this.deviceId, this.preKeys, this.signedPreKey, this.identityKey});

  factory PreKeyBundleModel.fromJson(Map<String, dynamic> json) => _$PreKeyBundleModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreKeyBundleModelToJson(this);
}

@JsonSerializable()
class PreKeyModel {
  int? id;
  String? key;

  PreKeyModel({this.id, this.key});

  factory PreKeyModel.fromJson(Map<String, dynamic> json) => _$PreKeyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreKeyModelToJson(this);
}

@JsonSerializable()
class SignedPreKeyModel {
  int? id;
  String? key;
  @JsonKey(name: 'sign')
  String? signature;

  SignedPreKeyModel({this.id, this.key, this.signature});

  factory SignedPreKeyModel.fromJson(Map<String, dynamic> json) => _$SignedPreKeyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignedPreKeyModelToJson(this);
}