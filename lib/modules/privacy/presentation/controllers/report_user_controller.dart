import 'package:chatdrop/modules/privacy/domain/services/privacy_service.dart';

class ReportUserController {
  final PrivacyService _privacyService = PrivacyService();

  Future<bool> report(String uid, String message) async {
    return await _privacyService.reportUser(uid, message);
  }
}