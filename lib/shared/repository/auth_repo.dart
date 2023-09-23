import 'package:chatdrop/shared/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../infra/services/api_client.dart';

// User Authentication Repository
class AuthRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = AuthRepository._();
  late String accountCreationKey;

  AuthRepository._() {
    accountCreationKey = dotenv.env['ACCOUNT_CREATION_KEY']!;
  }

  Future<Map<String, dynamic>?> signInWithGoogle({required String idToken, required Map<String, dynamic> preKeyBundle, required String? msgToken}) async {
    _apiClient.attachHeaders({
      'git': idToken,
    });
    var response = await _apiClient.post(
      path: 'account/v1/signin/google/',
      data: {'pre_key_bundle': preKeyBundle, 'msg_token': msgToken},
    );
    _apiClient.detachHeaders(['git']);
    return response.data;
  }

  Future<Map<String, dynamic>?> googleSignInAccountCreation({
    required String idToken,
    required String gsacToken,
    required String gender,
    required String dateOfBirth,
    required String password,
    required Map<String, dynamic> preKeyBundle,
    required String? msgToken
  }) async {
    _apiClient.attachHeaders({
      'git': idToken,
      'gsact': gsacToken,
      'ack': accountCreationKey,
    });
    var response = await _apiClient.post(
      path: 'account/v1/signin/gsac/',
      data: {
        'gender': gender == 'Male'
            ? 'M'
            : gender == 'Female'
            ? 'F'
            : 'O',
        'date_of_birth': dateOfBirth,
        'password': password,
        'pre_key_bundle': preKeyBundle,
        'msg_token': msgToken,
      },
    );
    _apiClient.detachHeaders(['git', 'gsact']);
    return response.data;
  }

  Future<Map<String, dynamic>?> login({required String email, required String password, required Map<String, dynamic> preKeyBundle, required String? msgToken}) async {
    var response = await _apiClient.post(
      path: 'account/v1/login/',
      data: {'email': email, 'password': password, 'pre_key_bundle': preKeyBundle, 'msg_token': msgToken},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> forgetPassword({required String email}) async {
    var response = await _apiClient.post(
      path: 'account/v1/recovery/password/',
      data: {'email': email},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> forgetPasswordOtpVerification({required String otp, required String proToken, required String prrToken}) async {
    _apiClient.attachHeaders({'prot': proToken, 'prrt': prrToken});
    var response = await _apiClient.post(
      path: 'account/v1/recovery/password/verify/',
      data: {'otp': otp},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> forgetPasswordOtpResent({required String proToken, required String prrToken}) async {
    _apiClient.attachHeaders({'prot': proToken, 'prrt': prrToken});
    var response = await _apiClient.post(path: 'account/v1/recovery/password/resent/otp/');
    return response.data;
  }

  Future<Map<String, dynamic>?> forgetPasswordSetNewPassword({required String password, required String prnpToken}) async {
    _apiClient.attachHeaders({'prnpt': prnpToken});
    var response = await _apiClient.post(
      path: 'account/v1/recovery/password/verify/new/',
      data: {'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> signup(
      {required String firstName,
      required String lastName,
      required String gender,
      required String dateOfBirth,
      required String email,
      required String password,
      required String rePassword,
      required String? msgToken,
      }) async {
    var response = await _apiClient.post(
      path: 'account/v1/signup/',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender == 'Male'
            ? 'M'
            : gender == 'Female'
                ? 'F'
                : 'O',
        'date_of_birth': dateOfBirth,
        'email': email,
        'password': password,
        'msg_token': msgToken,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> signupVerification(
      {required String otp,
      required String soToken,
      required String srToken,
      required Map<String, dynamic> preKeyBundle}) async {
    _apiClient.attachHeaders({
      'sot': soToken,
      'srt': srToken,
      'ack': accountCreationKey,
    });
    var response = await _apiClient.post(
      path: 'account/v1/signup/verify/',
      data: {'otp': otp, 'pre_key_bundle': preKeyBundle},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> signupOtpResent({required String soToken, required String srToken}) async {
    _apiClient.attachHeaders({'sot': soToken, 'srt': srToken});
   var response = await _apiClient.post(path: 'account/v1/signup/resent/otp/');
   return response.data;
  }

  Future<Map<String, dynamic>?> changePassword({required String currentPass, required String newPass}) async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.post(
      path: 'account/v1/account/password/change/',
      data: {'password': currentPass, 'new_password': newPass},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> changeUserNames({
    required String firstName,
    required String lastName,
    required String username,
    required String password
  }) async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.post(
      path: 'account/v1/account/names/change/',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> postPreKeyBundle(Map<String, dynamic> preKeyBundle) async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.post(
      path: 'account/v1/keys/prekeybundle/',
      data: preKeyBundle,
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> getPreKeyBundle(String uid) async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.get(
        path: 'account/v1/keys/prekeybundle/',
        queryParams: {'of': uid}
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> updateFCMessagingToken(String msgToken) async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.post(
      path: 'account/v1/fcm/token/',
      data: {'msg_token': msgToken},
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> loginCheck() async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.get(
      path: 'account/v1/login/check/',
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> logout() async {
    _apiClient.attachHeaders(UserService.authHeaders);
    final response = await _apiClient.post(
      path: 'account/v1/logout/',
      data: {},
    );
    return response.data;
  }
}
