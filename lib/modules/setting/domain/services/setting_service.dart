import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/modules/setting/data/repository/setting_repo.dart';
import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class SettingService {
  final SettingRepository _settingRepository = SettingRepository.instance;

  /// updates profile settings
  Future<bool> updateProfileSetting(String key, dynamic value) async {
    try {
      final response = ResponseCollector.collect(
          await _settingRepository.updateProfileSettings(key.toLowerCase(), value),
      );

      if(response.success) {
        UserService service = await UserService.instance;
        if(key == SettingConstant.isProfilePrivate) {
          service.putSettings({
            SettingConstant.isProfilePrivate: (value as bool)? 'TRUE': 'FALSE',
          });
        } else if(key == SettingConstant.defaultPostVisibility) {
          service.putSettings({
            SettingConstant.defaultPostVisibility: value.toString().toUpperCase(),
          });
        } else if (key == SettingConstant.defaultReelVisibility) {
          service.putSettings({
            SettingConstant.defaultReelVisibility: value.toString().toUpperCase(),
          });
        } else if(key == SettingConstant.allowChatGptInfoAccess) {
          service.putSettings({
            SettingConstant.allowChatGptInfoAccess: (value as bool)? 'TRUE': 'FALSE'
          });
        }
      }

      return response.success;
    } catch (e) {
      return false;
    }
  }
}