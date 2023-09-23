import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static Future<int> getAndroidSdkVersion() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return deviceInfo.version.sdkInt;
  }
}