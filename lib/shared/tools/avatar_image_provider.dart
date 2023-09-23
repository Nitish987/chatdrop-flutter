import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/settings/constants/assets_constant.dart';
import 'package:flutter/cupertino.dart';

class Avatar {
  static ImageProvider<Object> getAvatarProvider(String gender, String? photoUrl) {
    if (photoUrl == null || photoUrl == '') {
      if (gender == 'M') return const AssetImage(AvatarAssets.maleAvatar);
      if (gender == 'F') return const AssetImage(AvatarAssets.femaleAvatar);
      return const AssetImage(AvatarAssets.defaultAvatar);
    }
    return CachedNetworkImageProvider(photoUrl);
  }
}