import 'dart:math';

import 'package:chatdrop/infra/utilities/convert.dart';
import 'package:chatdrop/infra/utilities/encrypted_preferences.dart';
import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';
import 'package:chatdrop/shared/repository/auth_repo.dart';
import 'package:chatdrop/shared/repository/secret_chat_message_repo.dart';
import 'package:chatdrop/shared/repository/prekey_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../../infra/utilities/response.dart';

class UserService {
  late SharedPreferences _preferences;
  late EncryptedSharedPreferences _encryptedPreferences;
  static UserService? _userService;
  static IdentityKeyPair? _identityKeyPair;
  static int? _registrationId;
  static SignedPreKeyRecord? _signedPreKeyRecord;
  static InMemoryIdentityKeyStore? _inMemoryIdentityKeyStore;
  static InMemoryPreKeyStore? _inMemoryPreKeyStore;
  static InMemorySignedPreKeyStore? _inMemorySignedPreKeyStore;
  static bool isAuthenticated = false;
  static late Map<String, String> authHeaders;
  static late String webSocketAuthToken;
  static late String encryptionKey;
  static const deviceId = 2347815;
  static final PreKeyRepository _preKeyRepository = PreKeyRepository.instance;
  static final AuthRepository _authRepository = AuthRepository.instance;

  UserService._(SharedPreferences preferences, EncryptedSharedPreferences encryptedPreferences) {
    _preferences = preferences;
    _encryptedPreferences = encryptedPreferences;
  }

  /// returns user service instance
  static Future<UserService> get instance async {
    if (_userService == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      EncryptedSharedPreferences encryptedPreferences = EncryptedSharedPreferences();
      _userService = UserService._(preferences, encryptedPreferences);
      await _preKeyRepository.initialize();
      return _userService!;
    }
    return _userService!;
  }

  /// stores auth tokens in secure storage
  void putAuthTokens({required String authenticationToken, required String loginStateToken, required String websocketAuthenticationToken}) {
    _encryptedPreferences.set('AT', authenticationToken);
    _encryptedPreferences.set('LST', loginStateToken);
    _encryptedPreferences.set('WAT', websocketAuthenticationToken);
  }

  /// returns auth tokens in map from secure storage
  Future<Map<String, String?>> getAuthTokens() async {
    return {
      'AT': await _encryptedPreferences.get('AT'),
      'LST': await _encryptedPreferences.get('LST'),
    };
  }

  /// returns websocket auth token from secure storage
  Future<String?> getWebsocketAuthToken() async {
    return await _encryptedPreferences.get('WAT');
  }

  /// returns authentication headers from secure storage
  Future<Map<String, String>> _getAuthHeaders() async {
    Map<String, String?> tokens = await getAuthTokens();
    String uid = getUserId() ?? '';
    return {
      'uid': uid,
      'authorization': tokens['AT'] ?? '',
      'lst': tokens['LST'] ?? ''
    };
  }

  /// loads auth headers from tokens
  void loadAuthHeadersFromTokens(String uid, String at, String lst) {
    authHeaders = {
      'uid': uid,
      'authorization': at,
      'lst': lst,
    };
  }

  /// loads websocketAuthToken from tokens
  void loadWebsocketAuthFromToken(String wat) {
    webSocketAuthToken = wat;
  }

  /// returns particular auth token from secure storage
  dynamic getAuthToken(String key) {
    return _encryptedPreferences.get(key);
  }

  /// returns FCM token for cloud messaging
  Future<String?> getMessagingToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  /// update FCM token for cloud messaging
  Future<bool> updateMessageToken(String msgToken) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.updateFCMessagingToken(msgToken),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// store user id in local storage
  void putUserId(String uid) {
    _preferences.setString('UID', uid);
  }

  /// returns user id from local storage
  String? getUserId() {
    return _preferences.getString('UID');
  }

  /// stores auth state in local storage
  void setAuthenticated() {
    _preferences.setBool('AUTH_STATE', true);
    UserService.isAuthenticated = true;
  }

  /// stores auth state in local storage
  void setUnauthenticated() {
    _preferences.setBool('AUTH_STATE', false);
    UserService.isAuthenticated = false;
  }

  /// validated auth state
  bool getAuthenticationState() {
    bool? isAuthenticate = _preferences.getBool('AUTH_STATE');
    return isAuthenticate ?? false;
  }

  /// stores users settings in local storage
  void putSettings(Map<String, String> settings) {
    settings.forEach((key, value) {
      _preferences.setString(key, value);
    });
  }

  /// fetch user service from local storage
  String? getSetting(String key) {
    return _preferences.getString(key);
  }

  void putEncryptionKey(String key) {
    _encryptedPreferences.set('ENC_KEY', key);
  }

  Future<String?> getEncryptionKey() async {
    return await _encryptedPreferences.get('ENC_KEY');
  }

  /// loads encryption key
  void loadEncryptionKey(String key) {
    encryptionKey = key;
  }

  void putPreKeyNextId(int id) {
    _preferences.setInt(SettingConstant.preKeyNextId, id);
  }

  int? getPreKeyNextId() {
    return _preferences.getInt(SettingConstant.preKeyNextId);
  }

  /// generates identity key pairs, registration id and save them in secure storage.
  void generateSecureIdentity() {
    // generating identity key pairs and registration id
    UserService._identityKeyPair = generateIdentityKeyPair();
    UserService._registrationId = generateRegistrationId(true);
    UserService._signedPreKeyRecord = generateSignedPreKey(UserService._identityKeyPair!, 0);

    // saving keys in encrypted shared preferences
    String identityKeyPairBase64 = bytesToBase64(UserService._identityKeyPair!.serialize());
    String signedPreKeyRecordBase64 = bytesToBase64(UserService._signedPreKeyRecord!.serialize());
    _encryptedPreferences.set('IDENTITY_KEY_PAIR', identityKeyPairBase64);
    _encryptedPreferences.set('REGISTRATION_ID', UserService._registrationId!.toString());
    _encryptedPreferences.set('SIGNED_PRE_KEY_RECORD', signedPreKeyRecordBase64);
  }

  /// generates identity key pair from private key pair stored in secure storage
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    if (UserService._identityKeyPair == null) {
      // fetching identity key pair stored
      String? identityKeyPairBase64 = await _encryptedPreferences.get('IDENTITY_KEY_PAIR');

      UserService._identityKeyPair = IdentityKeyPair.fromSerialized(base64ToBytes(identityKeyPairBase64!));
    }
    return UserService._identityKeyPair!;
  }

  /// returns registration id stored in secure storage
  Future<int> getRegistrationId() async {
    if (UserService._registrationId == null) {
      String? registrationId = await _encryptedPreferences.get('REGISTRATION_ID');
      UserService._registrationId = int.parse(registrationId!);
    }
    return UserService._registrationId!;
  }

  /// returns signed pre-key record
  Future<SignedPreKeyRecord> getSignedPreKeyRecord() async {
    if(UserService._signedPreKeyRecord == null) {
      // fetching signed pre-key record stored
      String? signedPreKeyRecordBase64 = await _encryptedPreferences.get('SIGNED_PRE_KEY_RECORD');

      UserService._signedPreKeyRecord = SignedPreKeyRecord.fromSerialized(base64ToBytes(signedPreKeyRecordBase64!));
    }
    return UserService._signedPreKeyRecord!;
  }

  /// generates pre-keys
  List<PreKeyRecord> generateSecurePreKeys(int start, int count) {
    final preKeys = generatePreKeys(start, count);
    return preKeys;
  }

  /// returns identity key store
  Future<InMemoryIdentityKeyStore> getIdentityKeyStore() async {
    if (UserService._inMemoryIdentityKeyStore == null) {
      IdentityKeyPair identityKeyPair = await getIdentityKeyPair();
      int registrationId = await getRegistrationId();
      UserService._inMemoryIdentityKeyStore = InMemoryIdentityKeyStore(identityKeyPair, registrationId);
    }
    return UserService._inMemoryIdentityKeyStore!;
  }

  /// returns pre-key store
  InMemoryPreKeyStore getPreKeyStore() {
    UserService._inMemoryPreKeyStore ??= InMemoryPreKeyStore();
    return UserService._inMemoryPreKeyStore!;
  }

  /// returns Signed pre-key store
  InMemorySignedPreKeyStore getSignedPreKeyStore() {
    UserService._inMemorySignedPreKeyStore ??= InMemorySignedPreKeyStore();
    return UserService._inMemorySignedPreKeyStore!;
  }

  /// returns pre-key store with stored pre-keys
  Future<InMemoryPreKeyStore> fillPreKeyStore(List<PreKeyRecord> preKeyRecords) async {
    InMemoryPreKeyStore preKeyStore = getPreKeyStore();

    // storing pre-keys
    for (var p in preKeyRecords) {
      await preKeyStore.storePreKey(p.id, p);
    }
    return preKeyStore;
  }

  /// returns signed pre-key store with stored signed pre-key
  Future<InMemorySignedPreKeyStore> fillSignedPreKeyStore(SignedPreKeyRecord signedPreKeyRecord) async {
    InMemorySignedPreKeyStore signedPreKeyStore = getSignedPreKeyStore();

    // storing signed pre-key
    await signedPreKeyStore.storeSignedPreKey(signedPreKeyRecord.id, signedPreKeyRecord);
    return signedPreKeyStore;
  }

  /// generates and return new pre-key bundle model
  Future<PreKeyBundleModel> generateNewPreKeyBundleModel() async {
    /// generating identity keys
    generateSecureIdentity();

    /// fetching registration id
    int registrationId = await getRegistrationId();

    /// saving pre-key next id in user settings
    putPreKeyNextId(200);

    /// generating pre-keys
    List<PreKeyRecord> preKeyRecords = generateSecurePreKeys(0, 200);
    List<PreKeyModel> preKeys = preKeyRecords.map((preKey) {
      return PreKeyModel(
        id: preKey.id,
        key: bytesToBase64(preKey.getKeyPair().publicKey.serialize()),
      );
    }).toList();

    // storing pre-keys record in pre-key store
    UserService._inMemoryPreKeyStore = await fillPreKeyStore(preKeyRecords);
    // deleting pre-keys records for new pre-keys in database
    await UserService._preKeyRepository.deletePreKeysTableRecords();
    // storing pre-keys record in pre-keys database
    await UserService._preKeyRepository.storePreKeys(preKeyRecords);


    /// generating signed pre-key
    SignedPreKeyRecord signedPreKeyRecord = await getSignedPreKeyRecord();
    SignedPreKeyModel signedPreKey = SignedPreKeyModel(
      id: signedPreKeyRecord.id,
      key: bytesToBase64(
        signedPreKeyRecord.getKeyPair().publicKey.serialize(),
      ),
      signature: bytesToBase64(signedPreKeyRecord.signature),
    );

    // storing signed pre-key in signed pre-key store
    UserService._inMemorySignedPreKeyStore = await fillSignedPreKeyStore(signedPreKeyRecord);

    // identity key pair store
    UserService._inMemoryIdentityKeyStore = await getIdentityKeyStore();

    /// fetching identity key pair
    IdentityKeyPair identityKeyPair = await getIdentityKeyPair();
    String identityKey = bytesToBase64(identityKeyPair.getPublicKey().serialize());

    /// returning pre-key bundle model
    return PreKeyBundleModel(
      registrationId: registrationId,
      deviceId: deviceId,
      preKeys: preKeys,
      signedPreKey: signedPreKey,
      identityKey: identityKey,
    );
  }

  /// generates and return existing pre-key bundle model with new pre-keys
  Future<PreKeyBundleModel> generateExistingPreKeyBundleModel() async {
    /// fetching registration id
    int registrationId = await getRegistrationId();

    /// saving pre-key next id in user settings
    int preKeyNextId = getPreKeyNextId()!;
    putPreKeyNextId(preKeyNextId + 100);

    /// generating pre-keys
    List<PreKeyRecord> preKeyRecords = generateSecurePreKeys(preKeyNextId, 100);
    List<PreKeyModel> preKeys = preKeyRecords.map((preKey) {
      return PreKeyModel(
        id: preKey.id,
        key: bytesToBase64(preKey.getKeyPair().publicKey.serialize()),
      );
    }).toList();

    // storing pre-keys record in pre-key store
    UserService._inMemoryPreKeyStore = await fillPreKeyStore(preKeyRecords);
    // deleting pre-keys records for new pre-keys in database
    await UserService._preKeyRepository.deletePreKeysTableRecords();
    // storing pre-keys record in pre-keys database
    await UserService._preKeyRepository.storePreKeys(preKeyRecords);


    /// generating signed pre-key
    SignedPreKeyRecord signedPreKeyRecord = await getSignedPreKeyRecord();
    SignedPreKeyModel signedPreKey = SignedPreKeyModel(
      id: signedPreKeyRecord.id,
      key: bytesToBase64(
        signedPreKeyRecord.getKeyPair().publicKey.serialize(),
      ),
      signature: bytesToBase64(signedPreKeyRecord.signature),
    );

    // storing signed pre-key in signed pre-key store
    UserService._inMemorySignedPreKeyStore = await fillSignedPreKeyStore(signedPreKeyRecord);

    // identity key pair store
    UserService._inMemoryIdentityKeyStore = await getIdentityKeyStore();

    /// fetching identity key pair
    IdentityKeyPair identityKeyPair = await getIdentityKeyPair();
    String identityKey = bytesToBase64(identityKeyPair.getPublicKey().serialize());

    /// returning pre-key bundle model
    return PreKeyBundleModel(
      registrationId: registrationId,
      deviceId: deviceId,
      preKeys: preKeys,
      signedPreKey: signedPreKey,
      identityKey: identityKey,
    );
  }

  /// deleting used pre-key pair from pre-key store and database as well
  static Future<void> deletePreKeyFromStore(int id) async {
    try {
      UserService userService = await UserService.instance;
      await userService.getPreKeyStore().removePreKey(id);
      await _preKeyRepository.deletePreKey(id);
    } catch(e) {
      return;
    }
  }

  /// return current user pre-key bundle
  static Future<PreKeyBundleModel> getPreKeyBundleModel() async {
    UserService userService = await UserService.instance;
    int registrationId = await userService.getRegistrationId();

    Random random = Random();
    int selectedId = random.nextInt(userService.getPreKeyStore().store.length);
    while(! await userService.getPreKeyStore().containsPreKey(selectedId)) {
      selectedId = random.nextInt(userService.getPreKeyStore().store.length);
    }

    PreKeyRecord preKeyRecord = await userService.getPreKeyStore().loadPreKey(selectedId);

    final List<PreKeyModel> preKeys = [
      PreKeyModel(
        id: preKeyRecord.id,
        key: bytesToBase64(preKeyRecord.getKeyPair().publicKey.serialize()),
      )
    ];

    final SignedPreKeyRecord signedPreKeyRecord = await userService.getSignedPreKeyStore().loadSignedPreKey(0);
    final SignedPreKeyModel signedPreKey = SignedPreKeyModel(
      id: signedPreKeyRecord.id,
      key: bytesToBase64(signedPreKeyRecord.getKeyPair().publicKey.serialize()),
      signature: bytesToBase64(signedPreKeyRecord.signature),
    );

    final IdentityKeyPair identityKeyPair = await userService.getIdentityKeyPair();
    final String identityKey = bytesToBase64(identityKeyPair.getPublicKey().serialize());

    return PreKeyBundleModel(
      registrationId: registrationId,
      deviceId: deviceId,
      preKeys: preKeys,
      signedPreKey: signedPreKey,
      identityKey: identityKey,
    );
  }

  /// loads keys stores async
  static void loadKeysStoresAsync() async {
    if (isAuthenticated) {
      UserService userService = await UserService.instance;

      // loading signed pre-key store
      userService.getSignedPreKeyRecord().then((signedPreKeyRecord) {
        userService.fillSignedPreKeyStore(signedPreKeyRecord).then((inMemorySignedPreKeyStore) {
          _inMemorySignedPreKeyStore = inMemorySignedPreKeyStore;
        });
      });

      // loading pre-keys store
      _preKeyRepository.retrievePreKey().then((preKeyRecords) {
        userService.fillPreKeyStore(preKeyRecords).then((inMemoryPreKeyStore) {
          _inMemoryPreKeyStore = inMemoryPreKeyStore;
        });
      });

      // loading identity key pair store
      userService.getIdentityKeyStore().then((inMemoryIdentityKeyStore) {
        _inMemoryIdentityKeyStore = inMemoryIdentityKeyStore;
      });
    }
  }

  /// loads keys stores sync
  static void loadKeysStoresSync({Function? onFinish, Function? onError}) async {
    try {
      UserService userService = await UserService.instance;

      // loading signed pre-key store
      SignedPreKeyRecord signedPreKeyRecord = await userService.getSignedPreKeyRecord();
      _inMemorySignedPreKeyStore = await userService.fillSignedPreKeyStore(signedPreKeyRecord);

      // loading pre-keys store
      List<PreKeyRecord> preKeyRecords = await _preKeyRepository.retrievePreKey();
      _inMemoryPreKeyStore = await userService.fillPreKeyStore(preKeyRecords);

      // loading identity key pair store
      _inMemoryIdentityKeyStore = await userService.getIdentityKeyStore();

      if (onFinish != null) {
        onFinish();
      }
    } catch(e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  /// loads identity key pair, registration id and authentication data
  static void loadAuthenticationData({Function? onFinish, Function? onError}) async {
    try {
      UserService userService = await UserService.instance;

      // loading identity key pair and registration id
      _identityKeyPair = await userService.getIdentityKeyPair();
      _registrationId = await userService.getRegistrationId();

      // setting authenticated state
      isAuthenticated = userService.getAuthenticationState();
      // attaching auth headers to user service
      authHeaders = await userService._getAuthHeaders();
      // attaching websocket auth token to user service
      webSocketAuthToken = (await userService.getWebsocketAuthToken())!;
      // loading encryption key
      encryptionKey = (await userService.getEncryptionKey())!;

      if (onFinish != null) {
        onFinish();
      }
    } catch(e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  /// remove all database tables and user data
  void logoutUserService() async {
    // delete all pre-keys
    await _preKeyRepository.deletePreKeysTableRecords();
    await _preKeyRepository.close();

    // delete all message and recent
    SecretChatMessageRepository chatMessageRepository = SecretChatMessageRepository();
    await chatMessageRepository.init();
    await chatMessageRepository.deleteChatsTableRecords();
    await chatMessageRepository.close();

    // stops receiving fcm updates
    // await FirebaseMessaging.instance.deleteToken();

    // set auth state to unauthenticated
    setUnauthenticated();
    // user service instance to null
    _userService = null;
  }
}
