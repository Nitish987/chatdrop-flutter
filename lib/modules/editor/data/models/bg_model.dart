import 'package:chatdrop/settings/constants/assets_constant.dart';
import 'package:flutter/cupertino.dart';

class BgModel {
  final String name;
  final AssetImage bg;

  BgModel({required this.name, required this.bg});

  static List<BgModel> getBackgroundList() {
    return [
      BgModel(name: 'red.png', bg: const AssetImage(BackgroundAssets.red)),
      BgModel(name: 'yellow.png', bg: const AssetImage(BackgroundAssets.yellow)),
      BgModel(name: 'green.png', bg: const AssetImage(BackgroundAssets.green)),
      BgModel(name: 'blue.png', bg: const AssetImage(BackgroundAssets.blue)),
      BgModel(name: 'pink.png', bg: const AssetImage(BackgroundAssets.pink)),
      BgModel(name: 'rose.png', bg: const AssetImage(BackgroundAssets.rose)),
      BgModel(name: 'orange.png', bg: const AssetImage(BackgroundAssets.orange)),
    ];
  }
}