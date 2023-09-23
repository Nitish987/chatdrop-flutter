import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class DashboardController {
  final AuthService _authService = AuthService();

  void loadKeysStores() {
    UserService.loadKeysStoresAsync();
  }

  void updateFcmToken(String msgToken) async {
    UserService service = await UserService.instance;
    await service.updateMessageToken(msgToken);
  }

  Future<bool> isLoggedIn() async {
    return await _authService.loginCheck();
  }

  void logoutAuthenticatedUser() async {
    await _authService.logout();
  }
}