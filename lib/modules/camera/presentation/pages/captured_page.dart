import 'dart:io';

import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/message_forward_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class CapturedPage extends StatefulWidget {
  final FileType type;
  final String path;
  const CapturedPage({super.key,required this.type, required this.path});

  @override
  State<CapturedPage> createState() => _CapturedPageState();
}

class _CapturedPageState extends State<CapturedPage> {
  late ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;
  late VideoPlayerController _playerController;

  @override
  void initState() {
    if (widget.type == FileType.video) {
      _playerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.type == FileType.image)
            Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: Image.file(File(widget.path)),
              ),
            ),

          if (widget.type == FileType.video && _playerController.value.isInitialized)
            GestureDetector(
              onTap: () {
                if (_playerController.value.isPlaying) {
                  _playerController.pause();
                } else {
                  _playerController.play();
                }
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: _playerController.value.aspectRatio,
                  child: VideoPlayer(_playerController),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: Card(
        elevation: 1,
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Post
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                    child: const Icon(
                      Icons.post_add,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.post, arguments: {
                    'type': widget.type,
                    'file': File(widget.path),
                  });
                },
              ),

              /// Story
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                    child: const Icon(
                      Icons.history_toggle_off,
                      color: Colors.green,
                    ),
                  ),
                ),
                onTap: () {
                  if (widget.type == FileType.image) {
                    Navigator.pushNamed(
                      context,
                      Routes.imageEditor,
                      arguments: {'image_path': widget.path, 'bg_name': null},
                    ).then((path) {
                      if (path == null) throw Exception('Unable to add status');
                      Navigator.pushNamed(
                        context,
                        Routes.storyPost,
                        arguments: {'file_path': path, 'type': 'PHOTO'},
                      );
                    });
                  } else if(widget.type == FileType.video) {
                    Navigator.pushNamed(
                      context,
                      Routes.videoTrimmer,
                      arguments: {'video_path': widget.path},
                    ).then((path) {
                      if (path == null) throw Exception('Unable to add status');
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.storyPost,
                        arguments: {'file_path': path, 'type': 'VIDEO'},
                      );
                    });
                  }
                },
              ),

              /// Send
              InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.purple,
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                    child: const Icon(
                      Icons.send,
                      color: Colors.purple,
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      String contentType = 'TEXT';
                      if (widget.type == FileType.image) {
                        contentType = 'IMAGE';
                      } else if (widget.type == FileType.video) {
                        contentType = 'VIDEO';
                      }
                      return MessageForwardOptionSheet(
                        contentType: contentType,
                        attachment: File(widget.path),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.type == FileType.video) {
      _playerController.dispose();
    }
    super.dispose();
  }
}
