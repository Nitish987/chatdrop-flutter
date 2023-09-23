import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/repository/auth_repo.dart';
import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/models/prekey_bundle_model/prekey_bundle_model.dart';
import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository.instance;

  void _makeUserLoggedIn({required String uid, required String at, required String lst, required String wat, required String encKey, required ProfileSettingsModel settings}) async {
    UserService userService = await UserService.instance;
    userService.putUserId(uid);
    userService.putAuthTokens(
      authenticationToken: at,
      loginStateToken: lst,
      websocketAuthenticationToken: wat,
    );
    userService.loadAuthHeadersFromTokens(uid, at, lst);
    userService.loadWebsocketAuthFromToken(wat);
    userService.putEncryptionKey(encKey);
    userService.loadEncryptionKey(encKey);
    userService.putSettings({
      SettingConstant.isProfilePrivate: settings.isProfilePrivate! ? 'TRUE': 'FALSE',
      SettingConstant.defaultPostVisibility: settings.defaultPostVisibility!.toUpperCase().toString(),
      SettingConstant.defaultReelVisibility: settings.defaultReelVisibility!.toUpperCase().toString(),
      SettingConstant.allowChatGptInfoAccess: settings.allowChatGptInfoAccess! ? 'TRUE': 'FALSE',
    });
    userService.setAuthenticated();
  }

  void _makeUserLogout() async {
    UserService userService = await UserService.instance;
    userService.logoutUserService();
  }

  Future<Map<String, dynamic>> googleSignIn({required idToken}) async {
    try {
      final UserService userService = await UserService.instance;
      PreKeyBundleModel preKeyBundle = await userService.generateNewPreKeyBundleModel();
      String? msgToken = await userService.getMessagingToken();
      final response = ResponseCollector.collect(
        await _authRepository.signInWithGoogle(
          idToken: idToken,
          preKeyBundle: preKeyBundle.toJson(),
          msgToken: msgToken,
        ),
      );
      if (response.success) {
        if (response.data!.containsKey('gsact')) {
          return {'success': true, 'type': 'GSAC', 'token': response.data!['gsact']};
        } else {
          final fat = response.data!['fat'];
          final credentials = await FirebaseAuth.instance.signInWithCustomToken(fat);
          _makeUserLoggedIn(
            uid: credentials.user!.uid,
            at: response.data!['at'],
            lst: response.data!['lst'],
            wat: response.data!['wat'],
            encKey: response.data!['enc_key'],
            settings: ProfileSettingsModel.fromJson(response.data!['settings']),
          );
          return {'success': true, 'type': 'LOGGEDIN'};
        }
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> googleSignInAccountCreation({
    required String idToken,
    required String gsacToken,
    required String gender,
    required String dateOfBirth,
    required String password,
  }) async {
    try {
      UserService userService = await UserService.instance;
      PreKeyBundleModel preKeyBundle = await userService.generateNewPreKeyBundleModel();
      String? msgToken = await userService.getMessagingToken();
      final response = ResponseCollector.collect(
        await _authRepository.googleSignInAccountCreation(
          idToken: idToken,
          gsacToken: gsacToken,
          gender: gender,
          dateOfBirth: dateOfBirth,
          password: password,
          preKeyBundle: preKeyBundle.toJson(),
          msgToken: msgToken,
        ),
      );

      if (response.success) {
        final fat = response.data!['fat'];
        final credentials = await FirebaseAuth.instance.signInWithCustomToken(fat);
        _makeUserLoggedIn(
          uid: credentials.user!.uid,
          at: response.data!['at'],
          lst: response.data!['lst'],
          wat: response.data!['wat'],
          encKey: response.data!['enc_key'],
          settings: ProfileSettingsModel.fromJson(response.data!['settings']),
        );
        return {'success': true};
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final UserService userService = await UserService.instance;
      PreKeyBundleModel preKeyBundle = await userService.generateNewPreKeyBundleModel();
      String? msgToken = await userService.getMessagingToken();
      final response = ResponseCollector.collect(
        await _authRepository.login(
          email: email,
          password: password,
          preKeyBundle: preKeyBundle.toJson(),
          msgToken: msgToken,
        ),
      );

      if (response.success) {
        final fat = response.data!['fat'];
        final credentials = await FirebaseAuth.instance.signInWithCustomToken(fat);
        _makeUserLoggedIn(
          uid: credentials.user!.uid,
          at: response.data!['at'],
          lst: response.data!['lst'],
          wat: response.data!['wat'],
          encKey: response.data!['enc_key'],
          settings: ProfileSettingsModel.fromJson(response.data!['settings']),
        );
        return {'success': true};
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> forgetPassword({required String email}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.forgetPassword(email: email),
      );

      if (response.success) {
        return {
          'success': true,
          'proToken': response.data?['prot'],
          'prrToken': response.data?['prrt'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> forgetPasswordOtpVerification(
      {required String otp,
      required String proToken,
      required String prrToken}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.forgetPasswordOtpVerification(
            otp: otp, proToken: proToken, prrToken: prrToken),
      );

      if (response.success) {
        return {
          'success': true,
          'prnpToken': response.data?['prnpt'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> forgetPasswordOtpResent(
      {required String proToken, required String prrToken}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.forgetPasswordOtpResent(
            proToken: proToken, prrToken: prrToken),
      );

      if (response.success) {
        return {
          'success': true,
          'proToken': response.data?['prot'],
          'prrToken': response.data?['prrt'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> forgetPasswordSetNewPassword(
      {required String password, required String prnpToken}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.forgetPasswordSetNewPassword(password: password, prnpToken: prnpToken),
      );

      if (response.success) {
        return {
          'success': true,
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> signup(
      {required String firstName,
      required String lastName,
      required String gender,
      required String dateOfBirth,
      required String email,
      required String password,
      required String rePassword}) async {
    try {
      UserService userService = await UserService.instance;
      String? msgToken = await userService.getMessagingToken();
      final response = ResponseCollector.collect(
        await _authRepository.signup(
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          dateOfBirth: dateOfBirth,
          email: email,
          password: password,
          rePassword: rePassword,
          msgToken: msgToken,
        ),
      );

      if (response.success) {
        return {
          'success': true,
          'soToken': response.data?['sot'],
          'srToken': response.data?['srt']
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> signupVerification(
      {required String otp,
      required String soToken,
      required String srToken}) async {
    try {
      final UserService userService = await UserService.instance;
      PreKeyBundleModel preKeyBundle = await userService.generateNewPreKeyBundleModel();
      final response = ResponseCollector.collect(
        await _authRepository.signupVerification(
          otp: otp,
          soToken: soToken,
          srToken: srToken,
          preKeyBundle: preKeyBundle.toJson(),
        ),
      );

      if (response.success) {
        final fat = response.data!['fat'];
        final credentials = await FirebaseAuth.instance.signInWithCustomToken(fat);
        _makeUserLoggedIn(
          uid: credentials.user!.uid,
          at: response.data!['at'],
          lst: response.data!['lst'],
          wat: response.data!['wat'],
          encKey: response.data!['enc_key'],
          settings: ProfileSettingsModel.fromJson(response.data!['settings']),
        );
        return {'success': true};
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> signupOtpResent(
      {required String soToken, required String srToken}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.signupOtpResent(
            soToken: soToken, srToken: srToken),
      );

      if (response.success) {
        return {
          'success': true,
          'soToken': response.data?['sot'],
          'srToken': response.data?['srt'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> changePassword({required String currentPass, required String newPass}) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.changePassword(currentPass: currentPass, newPass: newPass),
      );
      if (response.success) {
        return {
          'success': true,
          'message': response.data?['message'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Something went wrong.'};
    }
  }

  /// changes user names
  Future<Map<String, dynamic>> changeUserNames({
    required String firstName,
    required String lastName,
    required String username,
    required String password
  }) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.changeUserNames(
          firstName: firstName,
          lastName: lastName,
          username: username,
          password: password
        ),
      );
      if (response.success) {
        return {
          'success': true,
          'message': response.data?['message'],
        };
      }
      return {'success': false, 'error': response.error};
    } catch (e) {
      return {'success': false, 'error': 'Change Limit exceeded. Try after 24 hours'};
    }
  }

  /// returns pre-key bundle of the user
  Future<bool> postPreKeyBundleModel() async {
    try {
      UserService userService = await UserService.instance;
      PreKeyBundleModel preKeyBundle = await userService.generateExistingPreKeyBundleModel();
      final response = ResponseCollector.collect(
        await _authRepository.postPreKeyBundle(preKeyBundle.toJson()),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// returns pre-key bundle of the user
  Future<PreKeyBundleModel?> getPreKeyBundleModel(String uid) async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.getPreKeyBundle(uid),
      );
      if (response.success) {
        final result = PreKeyBundleModel.fromJson(response.data?['prekey_bundle'] as Map<String, dynamic>);
        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// checks whether the user is authenticated or not
  Future<bool> loginCheck() async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.loginCheck(),
      );

      if (!response.success) {
        _makeUserLogout();
        return false;
      }

      return true;
    } catch (e) {
      _makeUserLogout();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = ResponseCollector.collect(
        await _authRepository.logout(),
      );

      if (response.success) {
        _makeUserLogout();
        await FirebaseAuth.instance.signOut();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
