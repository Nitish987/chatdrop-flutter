import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/widgets/reel.dart';
import 'package:flutter/material.dart';

class ReelShowcasePage extends StatelessWidget {
  const ReelShowcasePage({super.key, required this.reel, required this.sameUser});
  final ReelModel reel;
  final bool sameUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Reel(
        reel: reel,
        sameUser: sameUser,
      ),
    );
  }
}
