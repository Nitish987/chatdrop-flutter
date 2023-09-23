import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WebVideoViewerPage extends StatefulWidget {
  const WebVideoViewerPage({Key? key, required this.source}) : super(key: key);

  final String source;

  @override
  State<WebVideoViewerPage> createState() => _WebVideoViewerPageState();
}

class _WebVideoViewerPageState extends State<WebVideoViewerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.source))
      ..initialize().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Video'),
      ),
      body: _controller.value.isInitialized ? GestureDetector(
        onTap: () {
          if(_controller.value.isInitialized) {
            if(_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          }
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ) : const Loading(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller.value.isInitialized) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }
}
