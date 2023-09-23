import 'package:chatdrop/shared/controllers/post_video_controller.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../cubit/theme/theme_cubit.dart';
import '../cubit/theme/theme_state.dart';

class PostVideo extends StatefulWidget {
  const PostVideo({super.key, required this.id, required this.video, required this.controller});
  final String id;
  final PostVideoModel video;
  final PostVideoController controller;

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late ThemeState theme;
  late VideoPlayerController _playerController;

  @override
  void initState() {
    theme = BlocProvider.of<ThemeCubit>(context).state;
    _playerController = VideoPlayerController.networkUrl(Uri.parse(widget.video.url!))
      ..initialize().then((value) {
        widget.controller.initialize(_playerController, () {
          setState(() {});
        });

        setState(() {});
        _playerController.addListener(() {
          // changing state if video is finished
          if (_playerController.value.isInitialized && !_playerController.value.isPlaying && _playerController.value.duration == _playerController.value.position) { //checking the duration and position every time
            setState(() {});
          }

          if (!_playerController.value.isBuffering) {
            setState(() {});
          }
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.video.aspectRatio!,
      child: GestureDetector(
        onTap: () {
          if (_playerController.value.isInitialized) {
            if (_playerController.value.isPlaying) {
              _playerController.pause();
            } else {
              _playerController.play();
            }
            setState(() {});
          }
        },
        child: VisibilityDetector(
          key: Key(widget.id),
          onVisibilityChanged: (VisibilityInfo info) {
            if (_playerController.value.isInitialized) {
              if (_playerController.value.isPlaying) {
                _playerController.pause();
                setState(() {});
              }
            }
          },
          child: Stack(
            children: [
              if (_playerController.value.isInitialized)
                VideoPlayer(_playerController)
              else
                Container(color: Colors.grey),
              if (_playerController.value.isBuffering)
                const Align(
                  alignment: Alignment.center,
                  child: Loading(),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      /// video play button
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme == ThemeState.light ? Colors.white : Colors.black,
                        ),
                        child: Icon(
                          _playerController.value.isPlaying ? Icons.pause_outlined : Icons.play_arrow_rounded,
                          color: theme == ThemeState.light ? Colors.black : Colors.white,
                        ),
                      ),

                      /// video mute button
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          if (_playerController.value.volume == 0.0) {
                            _playerController.setVolume(50);
                          } else {
                            _playerController.setVolume(0.0);
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme == ThemeState.light ? Colors.white : Colors.black,
                          ),
                          child: Icon(
                            _playerController.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                            color: theme == ThemeState.light ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }
}
