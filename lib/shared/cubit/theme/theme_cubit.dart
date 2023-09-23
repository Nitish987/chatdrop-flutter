import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light) {
    readThemeState();
  }

  void readThemeState() async {
    UserService service = await UserService.instance;
    String? state = service.getSetting(SettingConstant.theme);
    if (state == null || state == 'LIGHT') {
      emit(ThemeState.light);
    } else {
      emit(ThemeState.dark);
    }
  }

  void changeTheme() {
    Future.delayed(const Duration(milliseconds: 200), () async {
      UserService service = await UserService.instance;
      if(state == ThemeState.light) {
        service.putSettings({SettingConstant.theme: 'DARK'});
        emit(ThemeState.dark);
      } else {
        service.putSettings({SettingConstant.theme: 'LIGHT'});
        emit(ThemeState.light);
      }
    });
  }
}