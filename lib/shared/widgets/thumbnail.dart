import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum ThumbnailSource { network, file }

class Thumbnail extends StatefulWidget {
  final double width;
  final double height;
  final String source;
  final bool isCircular;
  final ThumbnailSource thumbnailSource;

  const Thumbnail(
      {Key? key,
      this.width = 100,
      this.height = 100,
      required this.thumbnailSource,
      required this.source,
      this.isCircular = false})
      : super(key: key);

  const Thumbnail.network(
      {Key? key,
      this.width = 100,
      this.height = 100,
      this.thumbnailSource = ThumbnailSource.network,
      required this.source,
      this.isCircular = false})
      : super(key: key);

  const Thumbnail.file(
      {Key? key,
      this.width = 100,
      this.height = 100,
      this.thumbnailSource = ThumbnailSource.file,
      required this.source,
      this.isCircular = false})
      : super(key: key);

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.thumbnailSource == ThumbnailSource.network) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.source))
        ..initialize().then((value) => setState(() {}));
    } else {
      _controller = VideoPlayerController.file(File(widget.source))
        ..initialize().then((value) => setState(() {}));
    }
  }

  Widget getThumbnailChild() {
    if (_controller.value.isInitialized) {
      if (widget.isCircular) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: VideoPlayer(_controller),
        );
      }
      return VideoPlayer(_controller);
    }
    if(widget.isCircular) {
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: widget.isCircular ? BorderRadius.circular(100) : null,
      ),
      child: getThumbnailChild(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
