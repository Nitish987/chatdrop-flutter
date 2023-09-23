import 'package:chatdrop/settings/constants/setting_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardTabSwitcherProvider with ChangeNotifier {
  final _keyName = SettingConstant.dashboardTabIndex;
  static SharedPreferences? _preferences;
  int _tabIndex = 0;

  DashboardTabSwitcherProvider() {
    _getSavedTabIndexState();
  }

  void _saveTabIndexState() {
    if (_preferences == null) {
      SharedPreferences.getInstance().then((preferences) {
        _preferences = preferences;
        _preferences!.setInt(_keyName, _tabIndex);
      });
    } else {
      _preferences!.setInt(_keyName, _tabIndex);
    }
  }

  void _getSavedTabIndexState() async {
    _preferences = await SharedPreferences.getInstance();
    _tabIndex = _preferences!.getInt(_keyName) ?? 0;
    notifyListeners();
  }

  void setTabIndex(int tabIndex) {
    _tabIndex = tabIndex;
    _saveTabIndexState();
    notifyListeners();
  }

  int get tabIndex => _tabIndex;
}