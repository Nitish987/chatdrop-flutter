import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class ReelPostController {
  List<String> reelVisibilityChoices = ['PUBLIC', 'ONLY_FRIENDS', 'PRIVATE'];
  String reelVisibility = 'PUBLIC';

  void initialize(Function onInitialized) async {
    UserService service = await UserService.instance;
    reelVisibility = service.getSetting(SettingConstant.defaultReelVisibility) ?? 'PUBLIC';
    onInitialized();
  }
}