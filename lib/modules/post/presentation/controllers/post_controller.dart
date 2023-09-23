import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class PostController {
  List<String> postVisibilityChoices = ['PUBLIC', 'ONLY_FRIENDS', 'PRIVATE'];
  String postVisibility = 'PUBLIC';

  void initialize(Function onInitialized) async {
    UserService service = await UserService.instance;
    postVisibility = service.getSetting(SettingConstant.defaultPostVisibility) ?? 'PUBLIC';
    onInitialized();
  }
}