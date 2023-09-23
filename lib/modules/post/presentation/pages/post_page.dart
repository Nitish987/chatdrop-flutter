import 'dart:io';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:chatdrop/infra/utilities/file_type.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_bloc.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_event.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_state.dart';
import 'package:chatdrop/modules/post/presentation/controllers/post_controller.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/api/video_editor_api.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/tools/web_visit.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, this.type, this.file}) : super(key: key);
  final FileType? type;
  final File? file;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late ThemeState theme;
  final PostController postController = PostController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  late VideoPlayerController _playerController;
  late List<String> _selectedImages;
  late List<double> _selectedImagesAspectRatios;
  late String _selectedVideo;
  late double _selectedVideoAspectRatio;

  /// function for picking image for post
  void _pickImage() async {
    try {
      List<XFile> files = await _imagePicker.pickMultiImage();
      for (var file in files) {
        final decodedImage = await decodeImageFromList(await file.readAsBytes());
        _selectedImages.add(file.path);
        _selectedImagesAspectRatios.add(decodedImage.width / decodedImage.height);
      }
      setState(() {});
    } catch (e) {
      return;
    }
  }

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

  void _post() async {
    bool isText = _textController.value.text.isNotEmpty;
    bool isPhoto = _selectedImages.isNotEmpty;
    bool isVideo = _selectedVideo.isNotEmpty;

    if(isVideo && _playerController.value.isInitialized && _playerController.value.isPlaying) {
      _playerController.pause();
    }

    String thumbnailPath = '';
    if (isVideo) {
      thumbnailPath = (await VideoEditorApi.generateThumbnail(_selectedVideo))!;
    }

    String hashtags = extractDetections(_textController.value.text.trim(), detectionRegExp()!).join(',');

    if (mounted) {
      if (isText && isPhoto) {
        BlocProvider.of<PostBloc>(context).add(AddTextPhotoPostEvent(
          visibility: postController.postVisibility,
          hashtags: hashtags,
          text: _textController.value.text,
          photosPath: _selectedImages,
          aspectRatios: _selectedImagesAspectRatios,
        ));
      } else if (isText && isVideo) {
        BlocProvider.of<PostBloc>(context).add(AddTextVideoPostEvent(
          visibility: postController.postVisibility,
          hashtags: hashtags,
          text: _textController.value.text,
          videoPath: _selectedVideo,
          aspectRatio: _selectedVideoAspectRatio,
          thumbnailPath: thumbnailPath,
        ));
      } else if (isPhoto) {
        BlocProvider.of<PostBloc>(context).add(AddPhotoPostEvent(
          visibility: postController.postVisibility,
          hashtags: hashtags,
          photosPath: _selectedImages,
          aspectRatios: _selectedImagesAspectRatios,
        ));
      } else if (isVideo) {
        BlocProvider.of<PostBloc>(context).add(AddVideoPostEvent(
          visibility: postController.postVisibility,
          hashtags: hashtags,
          videoPath: _selectedVideo,
          aspectRatio: _selectedVideoAspectRatio,
          thumbnailPath: thumbnailPath,
        ));
      } else if (isText) {
        BlocProvider.of<PostBloc>(context).add(AddTextPostEvent(
          visibility: postController.postVisibility,
          hashtags: hashtags,
          text: _textController.value.text,
        ));
      }
    }
  }

  IconData _getPostVisibilityIcon() {
    switch (postController.postVisibility) {
      case 'ONLY_FRIENDS' : return Icons.people_outline;
      case 'PRIVATE' : return Icons.lock_outline;
    }
    return Icons.public_outlined;
  }

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;
    postController.initialize(() {
      setState(() {});
    });
    _selectedImages = [];
    _selectedImagesAspectRatios = [];
    _selectedVideo = '';
    _selectedVideoAspectRatio = 1;

    /// pre-defined post page content
    if (widget.type != null && widget.file != null) {
      if (widget.type == FileType.image) {
        decodeImageFromList(widget.file!.readAsBytesSync()).then((decodedImage) {
          _selectedImages.add(widget.file!.path);
          _selectedImagesAspectRatios.add(decodedImage.width / decodedImage.height);
          setState(() {});
        });
      } else if (widget.type == FileType.video) {
        _playerController = VideoPlayerController.file(File(widget.file!.path));
        _playerController.initialize().then((value) {
          _selectedVideo = widget.file!.path;
          _selectedVideoAspectRatio = _playerController.value.aspectRatio;
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Add Post'),
        actions: [
          BlocConsumer<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostingState) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Loading(),
                );
              }
              return IconButton(
                onPressed: () {
                  _post();
                },
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.blue,
                ),
              );
            },
            listener: (context, state) {
              if (state is PostFailedState) {
                ErrorSnackBar.show(context, state.error);
              } else if (state is PostedState) {
                SuccessSnackBar.show(context, 'Posted');
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                icon: Icon(_getPostVisibilityIcon()),
                value: postController.postVisibility,
                underline: Container(color: Colors.transparent),
                isExpanded: true,
                items: postController.postVisibilityChoices.map((value) {
                    final text = value.split('_').join(' ');
                    return DropdownMenuItem(
                      value: value,
                      child: Text(text),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    postController.postVisibility = value!;
                  });
                },
              ),
              const Text(
                "Write what's on your mind",
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
                  hintText: 'your post message here',
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                ),
                onChanged: (value) {
                  if (value.startsWith('http') || value.isEmpty) {
                    setState(() {});
                  } else if(value.endsWith('@')) {
                    Future.delayed(const Duration(milliseconds: 100),() {
                      Navigator.pushNamed(context, Routes.myFriendList).then((user) {
                        if(user != null) {
                          _textController.text = _textController.text + (user as UserModel).username!;
                        }
                      });
                    });
                  }
                },
              ),

              /// written text
              if (_textController.value.text.startsWith('http') && !_textController.value.text.contains(' '))
                AnyLinkPreview(
                  link: _textController.value.text,
                  backgroundColor: theme == ThemeState.light? Colors.white: Colors.black,
                  errorWidget: Container(
                    padding: const EdgeInsets.all(20),
                    color: theme == ThemeState.light? Colors.white: Colors.black,
                    child: const Text('Unable to load link preview.'),
                  ),
                  onTap: () {
                    webVisit(_textController.value.text);
                  },
                ),
              const SizedBox(height: 10),

              /// selected photos
              if (_selectedImages.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Image.file(
                              File(_selectedImages[index].toString()),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: theme == ThemeState.dark? Colors.black: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                  _selectedImagesAspectRatios.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              /// selected video
              if (_selectedVideo.isNotEmpty)
                Stack(
                  children: [
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: theme == ThemeState.dark? Colors.black: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (_playerController.value.isInitialized) {
                              _playerController.dispose();
                            }
                            setState(() {
                              _selectedVideo = '';
                              _selectedVideoAspectRatio = 1;
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: (_selectedImages.isEmpty && _selectedVideo.isEmpty)
          ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'image-btn',
            onPressed: () {
              _pickImage();
            },
            child: const Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'video-btn',
            onPressed: () {
              _pickVideo();
            },
            child: const Icon(
              Icons.videocam_outlined,
              color: Colors.white,
            ),
          ),
        ],
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(_selectedVideo.isNotEmpty) {
      _playerController.dispose();
    }
  }
}
