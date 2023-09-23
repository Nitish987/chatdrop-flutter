import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/services/friend_service.dart';
import 'package:chatdrop/shared/services/reel_service.dart';

class ReelController {
  final ReelService _reelService = ReelService();
  final FriendService _friendService = FriendService();

  Future<void> follow(UserModel user) async {
    await _friendService.sendFollowRequest(user.uid!);
  }

  void giveReelView(ReelModel reel) {
    _reelService.giveReelView(reel.id!);
  }
}