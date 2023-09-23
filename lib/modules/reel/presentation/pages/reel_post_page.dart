import 'dart:io';

import 'package:chatdrop/modules/reel/presentation/bloc/reel/reel_bloc.dart';
import 'package:chatdrop/modules/reel/presentation/controllers/reel_post_controller.dart';
import 'package:chatdrop/shared/api/video_editor_api.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../bloc/reel/reel_event.dart';
import '../bloc/reel/reel_state.dart';

class ReelPostPage extends StatefulWidget {
  const ReelPostPage({super.key, required this.file, this.audio});
  final File? file;
  final AudioModel? audio;

  @override
  State<ReelPostPage> createState() => _ReelPostPageState();
}

class _ReelPostPageState extends State<ReelPostPage> {
  final ReelPostController _reelController = ReelPostController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  late VideoPlayerController _playerController;
  late String _selectedVideo;
  late double _selectedVideoAspectRatio;

  /// function for picking image for post
  void _pickVideo() async {
    try {
      XFile? file = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        _playerController = VideoPlayerController.file(File(file.path));
        await _playerController.initialize();
        _selectedVideo = file.path;
        _selectedVideoAspectRatio = _playerController.value.aspectRatio;
        setState(() {});
      }
    } catch (e) {
      return;
    }
  }

  void _postReel() {
    if(_playerController.value.isInitialized && _playerController.value.isPlaying) {
      _playerController.pause();
    }

    int videoDurationSeconds = _playerController.value.duration.inSeconds;
    if (videoDurationSeconds > 60) {
      ErrorSnackBar.show(context, 'Reel must be of 60 seconds or less.');
      return;
    }

    VideoEditorApi.generateThumbnail(_selectedVideo).then((thumbnailPath) {
      if (thumbnailPath == null) {
        ErrorSnackBar.show(context, 'Unable to post reel.');
        return;
      }

      String hashtags = extractDetections(_textController.value.text.trim(), detectionRegExp()!).join(',');

      BlocProvider.of<ReelBloc>(context).add(AddReelEvent(
        visibility: _reelController.reelVisibility,
        hashtags: hashtags,
        videoPath: _selectedVideo,
        thumbnailPath: thumbnailPath,
        aspectRatio: _selectedVideoAspectRatio,
        text: _textController.value.text,
        audioId: widget.audio == null ? 0 : widget.audio!.id!,
      ));
    });
  }

  IconData _getPostVisibilityIcon() {
    switch (_reelController.reelVisibility) {
      case 'ONLY_FRIENDS' : return Icons.people_outline;
      case 'PRIVATE' : return Icons.lock_outline;
    }
    return Icons.public_outlined;
  }

  @override
  void initState() {
    _reelController.initialize(() {
      setState(() {});
    });
    _selectedVideo = '';
    _selectedVideoAspectRatio = 1;

    /// pre-defined post page content
    if (widget.file != null && widget.audio != null) {
      _playerController = VideoPlayerController.file(File(widget.file!.path));
      _playerController.initialize().then((value) {
        _selectedVideo = widget.file!.path;
        _selectedVideoAspectRatio = _playerController.value.aspectRatio;
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Add Reel'),
        actions: [
          BlocConsumer<ReelBloc, ReelState>(
            builder: (context, state) {
              if (state is ReelPostingState) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Loading(),
                );
              }
              return IconButton(
                onPressed: () {
                  _postReel();
                },
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.blue,
                ),
              );
            },
            listener: (context, state) {
              if (state is ReelFailedState) {
                ErrorSnackBar.show(context, state.error);
              } else if (state is ReelPostedState) {
                SuccessSnackBar.show(context, 'Posted');
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton(
                icon: Icon(_getPostVisibilityIcon()),
                value: _reelController.reelVisibility,
                underline: Container(color: Colors.transparent),
                isExpanded: true,
                items: _reelController.reelVisibilityChoices.map((value) {
                  final text = value.split('_').join(' ');
                  return DropdownMenuItem(
                    value: value,
                    child: Text(text),
                  );
                },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _reelController.reelVisibility = value!;
                  });
                },
              ),
              const Text(
                "Write reel description",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DetectableTextField(
                controller: _textController,
                detectionRegExp: detectionRegExp()!,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Reel description',
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                ),
              ),
              if (_selectedVideo.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    if (_playerController.value.isInitialized) {
                      if (_playerController.value.isPlaying) {
                        _playerController.pause();
                      } else {
                        _playerController.play();
                      }
                    }
                  },
                  child: _playerController.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _playerController.value.aspectRatio,
                    child: VideoPlayer(_playerController),
                  )
                      : Container(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedVideo.isEmpty ? FloatingActionButton(
        heroTag: 'video-btn',
        onPressed: () {
          _pickVideo();
        },
        child: const Icon(
          Icons.video_camera_back_outlined,
          color: Colors.white,
        ),
      ) : null,
    );
  }

  @override
  void dispose() {
    if(_selectedVideo.isNotEmpty) {
      _playerController.dispose();
    }
    super.dispose();
  }
}
