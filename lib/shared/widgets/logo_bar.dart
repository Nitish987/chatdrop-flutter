import 'package:chatdrop/settings/constants/assets_constant.dart';
import 'package:flutter/material.dart';

class LogoBar extends StatelessWidget {
  const LogoBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          LogoAssets.chatdrop,
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 10),
        const Text(
          'chatdrop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
