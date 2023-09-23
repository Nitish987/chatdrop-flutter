import 'dart:io';

import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';

class FileImageViewerPage extends StatelessWidget {
  const FileImageViewerPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Photo'),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.file(File(path)),
        ),
      ),
    );
  }
}
