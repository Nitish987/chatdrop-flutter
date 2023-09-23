import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:flutter/material.dart';

class WebImageViewerPage extends StatelessWidget {
  const WebImageViewerPage({Key? key, required this.source}) : super(key: key);

  final String source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Photo'),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          child: CachedNetworkImage(
            imageUrl: source,
          ),
        ),
      ),
    );
  }
}
