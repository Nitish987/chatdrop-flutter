import 'dart:convert';
import 'dart:typed_data';

import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignalProtocolService {
  final InMemorySessionStore _sessionStore = InMemorySessionStore();
  late SignalProtocolAddress _remoteAddress;

  /// initializing signal protocol
  static Future<SignalProtocolService> init(String remoteUserUid) async {
    // signal protocol object
    SignalProtocolService protocolService = SignalProtocolService();
    // signal protocol address
    SignalProtocolAddress remoteAddress = SignalProtocolAddress(remoteUserUid, UserService.deviceId);
    protocolService._remoteAddress = remoteAddress;
    return protocolService;
  }

  /// creating signal protocol session
  Future<SessionCipher> _createSession(PreKeyBundle preKeyBundle) async {
    UserService userService = await UserService.instance;

    final identityKeyStore = await userService.getIdentityKeyStore();
    final preKeyStore = userService.getPreKeyStore();
    final signedPreKeyStore = userService.getSignedPreKeyStore();

    final sessionBuilder = SessionBuilder(
      _sessionStore,
      preKeyStore,
      signedPreKeyStore,
      identityKeyStore,
      _remoteAddress,
    );

    // validating pre-key bundle
    await sessionBuilder.processPreKeyBundle(preKeyBundle);

    final sessionCipher = SessionCipher(_sessionStore, preKeyStore, signedPreKeyStore, identityKeyStore, _remoteAddress);
    return sessionCipher;
  }

  /// encrypt message
  Future<String> encryptMessage(PreKeyBundleModel model, String message) async {
    // creating pre-key bundle
    final preKeyBundle = PreKeyBundle(
      model.registrationId!,
      model.deviceId!,
      model.preKeys![0].id,
      Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.preKeys![0].key.toString())).serialize(), 1),
      model.signedPreKey!.id as int,
      Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.signedPreKey!.key.toString())).serialize(), 1),
      base64ToBytes(model.signedPreKey!.signature.toString()),
      IdentityKey(Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.identityKey.toString())).serialize(), 1)),
    );

    // encryption session begins
    final sessionCipher = await _createSession(preKeyBundle);
    final ciphertext = await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(message)));
    final preKeySignalMessage = PreKeySignalMessage(ciphertext.serialize());
    final cipher = bytesToBase64(preKeySignalMessage.serialize());
    return cipher;
  }

  /// decrypt message
  Future<String> decryptMessage(PreKeyBundleModel model, String cipher) async {
    // creating pre-key bundle
    final preKeyBundle = PreKeyBundle(
      model.registrationId!,
      model.deviceId!,
      model.preKeys![0].id,
      Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.preKeys![0].key.toString())).serialize(), 1),
      model.signedPreKey!.id as int,
      Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.signedPreKey!.key.toString())).serialize(), 1),
      base64ToBytes(model.signedPreKey!.signature.toString()),
      IdentityKey(Curve.decodePoint(DjbECPublicKey(base64ToBytes(model.identityKey.toString())).serialize(), 1)),
    );

    // decryption session begins
    final sessionCipher = await _createSession(preKeyBundle);
    final preKeySignalMessage = PreKeySignalMessage(base64ToBytes(cipher));
    final messageBytes = await sessionCipher.decrypt(preKeySignalMessage);
    final message = bytesToString(messageBytes);
    return message;
  }
}
