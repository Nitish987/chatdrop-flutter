import 'dart:io';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_bloc.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_event.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class StoryPostPage extends StatefulWidget {
  const StoryPostPage({Key? key, required this.filePath, required this.type}) : super(key: key);

  final String filePath;
  final String type;

  @override
  State<StoryPostPage> createState() => _StoryPostPageState();
}

class _StoryPostPageState extends State<StoryPostPage> {
  final TextEditingController _textController = TextEditingController();
  late VideoPlayerController _playerController;
  late ThemeState theme;

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;

    if (widget.type == 'VIDEO') {
      _playerController = VideoPlayerController.file(File(widget.filePath));
      _playerController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Add Story'),
      ),
      body: Center(
        child: (widget.type == 'TEXT' || widget.type == 'PHOTO')
            ? Image.file(File(widget.filePath))
            : GestureDetector(
                onTap: () {
                  if (_playerController.value.isInitialized) {
                    if (_playerController.value.isPlaying) {
                      _playerController.pause();
                    } else {
                      _playerController.play();
                    }
                  }
                },
                child: VideoPlayer(_playerController),
              ),
      ),
      floatingActionButton: BlocConsumer<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryPostingState) {
            return FloatingActionButton(
              onPressed: () {},
              backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
              child: const Loading(),
            );
          }
          return FloatingActionButton(
            onPressed: () {
              final storyBloc = BlocProvider.of<StoryBloc>(context);
              switch(widget.type) {
                case 'TEXT':
                  storyBloc.add(AddTextStoryEvent(widget.filePath));
                  break;
                case 'PHOTO':
                  storyBloc.add(AddPhotoStoryEvent(widget.filePath, _textController.value.text));
                  break;
                case 'VIDEO':
                  storyBloc.add(AddVideoStoryEvent(widget.filePath, _textController.value.text));
                  break;
              }
            },
            child: const Icon(Icons.send_outlined),
          );
        },
        listener: (context, state) {
          if (state is StoryFailedState) {
            ErrorSnackBar.show(context, state.error);
          } else if (state is StoryAddedState) {
            SuccessSnackBar.show(context, 'Story Posted.');
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          }
        },
      ),
      bottomSheet: widget.type != 'TEXT' ? Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: _textController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Your Message',
            prefixIcon: Icon(
              Icons.message_outlined,
              color: Colors.blue,
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)
            ),
          ),
        ),
      ): const SizedBox(height: 0),
    );
  }
}
