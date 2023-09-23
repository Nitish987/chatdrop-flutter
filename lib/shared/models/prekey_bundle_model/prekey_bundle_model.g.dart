// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prekey_bundle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreKeyBundleModel _$PreKeyBundleModelFromJson(Map<String, dynamic> json) =>
    PreKeyBundleModel(
      registrationId: json['reg_id'] as int?,
      deviceId: json['device_id'] as int?,
      preKeys: (json['prekeys'] as List<dynamic>?)
          ?.map((e) => PreKeyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      signedPreKey: json['signed_prekey'] == null
          ? null
          : SignedPreKeyModel.fromJson(
              json['signed_prekey'] as Map<String, dynamic>),
      identityKey: json['identity_key'] as String?,
    );

Map<String, dynamic> _$PreKeyBundleModelToJson(PreKeyBundleModel instance) =>
    <String, dynamic>{
      'reg_id': instance.registrationId,
      'device_id': instance.deviceId,
      'prekeys': instance.preKeys,
      'signed_prekey': instance.signedPreKey,
      'identity_key': instance.identityKey,
    };

PreKeyModel _$PreKeyModelFromJson(Map<String, dynamic> json) => PreKeyModel(
      id: json['id'] as int?,
      key: json['key'] as String?,
    );

Map<String, dynamic> _$PreKeyModelToJson(PreKeyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
    };

SignedPreKeyModel _$SignedPreKeyModelFromJson(Map<String, dynamic> json) =>
    SignedPreKeyModel(
      id: json['id'] as int?,
      key: json['key'] as String?,
      signature: json['sign'] as String?,
    );

Map<String, dynamic> _$SignedPreKeyModelToJson(SignedPreKeyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'sign': instance.signature,
    };
