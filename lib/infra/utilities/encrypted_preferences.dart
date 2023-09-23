import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptedSharedPreferences {
  FlutterSecureStorage? _secureStorage;

  EncryptedSharedPreferences() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  void set(String key, String value) async {
    await _secureStorage?.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    return await _secureStorage?.read(key: key);
  }

  void delete(String key) async {
    await _secureStorage?.delete(key: key);
  }
}
