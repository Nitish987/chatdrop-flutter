import 'package:chatdrop/modules/setting/domain/services/setting_service.dart';
import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SettingController {
  final SettingService _settingService = SettingService();

  /// states
  late bool isProfilePrivate = false;
  late String postVisibility = 'public';
  late String reelVisibility = 'public';
  late bool allowChatGptInfoAccess = false;

  void initialize(Function onInitialized) async {
    UserService service = await UserService.instance;
    isProfilePrivate = service.getSetting(SettingConstant.isProfilePrivate) == 'TRUE';
    postVisibility = service.getSetting(SettingConstant.defaultPostVisibility)!.toLowerCase();
    reelVisibility = service.getSetting(SettingConstant.defaultReelVisibility)!.toLowerCase();
    allowChatGptInfoAccess = service.getSetting(SettingConstant.allowChatGptInfoAccess) == 'TRUE';
    onInitialized();
  }

  Future<bool> setProfilePrivateState(bool value) async {
    return await _settingService.updateProfileSetting(SettingConstant.isProfilePrivate, value);
  }

  Future<bool> updatePostVisibility(String visibility) async {
    return await _settingService.updateProfileSetting(SettingConstant.defaultPostVisibility, visibility);
  }

  Future<bool> updateReelVisibility(String visibility) async {
    return await _settingService.updateProfileSetting(SettingConstant.defaultReelVisibility, visibility);
  }

  Future<bool> setAllowChatGptInfoAccess(bool value) async {
    return await _settingService.updateProfileSetting(SettingConstant.allowChatGptInfoAccess, value);
  }
}