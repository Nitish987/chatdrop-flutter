import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({Key? key, this.title = 'chatdrop'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
