import 'dart:typed_data';

import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';

class MemoryImageViewerPage extends StatelessWidget {
  const MemoryImageViewerPage({Key? key, required this.bytes})
      : super(key: key);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Photo'),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.memory(bytes),
        ),
      ),
    );
  }
}
