import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_bloc.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_event.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_state.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/messages.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/widgets/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class StoryConfigPage extends StatefulWidget {
  const StoryConfigPage({Key? key}) : super(key: key);

  @override
  State<StoryConfigPage> createState() => _StoryConfigPageState();
}

class _StoryConfigPageState extends State<StoryConfigPage> {
  final ImagePicker _imagePicker = ImagePicker();
  late ThemeState theme;

  /// function for picking background for story
  void _pickTextBg() async {
    try {
      final bgName =
          await Navigator.pushNamed(context, Routes.backgroundSelector);
      if (bgName != null && mounted) {
        final path = await Navigator.pushNamed(
          context,
          Routes.imageEditor,
          arguments: {'image_path': null, 'bg_name': bgName},
        );
        if (path == null) throw Exception('Unable to add status');
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.storyPost,
            arguments: {'file_path': path, 'type': 'TEXT'},
          );
        }
      }
    } catch (e) {
      return;
    }
  }

  /// function for picking image for story
  void _pickImage() async {
    try {
      XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null && mounted) {
        final path = await Navigator.pushNamed(
          context,
          Routes.imageEditor,
          arguments: {'image_path': file.path, 'bg_name': null},
        );
        if (path == null) throw Exception('Unable to add status');
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.storyPost,
            arguments: {'file_path': path, 'type': 'PHOTO'},
          );
        }
      }
    } catch (e) {
      return;
    }
  }

  /// function for picking video for story
  void _pickVideo() async {
    try {
      XFile? file = await _imagePicker.pickVideo(source: ImageSource.gallery);
      if (file != null && mounted) {
        final path = await Navigator.pushNamed(
          context,
          Routes.videoTrimmer,
          arguments: {'video_path': file.path},
        );
        if (path == null) throw Exception('Unable to add status');
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            Routes.storyPost,
            arguments: {'file_path': path, 'type': 'VIDEO'},
          );
        }
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    theme = BlocProvider.of<ThemeCubit>(context).state;

    // fetching all stories
    BlocProvider.of<StoryBloc>(context).add(FetchStoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'My Stories'),
      ),

      /// story bloc builder for state management
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryFailedState) {
            return ErrorMessage(message: state.error);
          } else if (state is StoryListedState) {
            /// showing no story posted
            if (state.stories.isEmpty) {
              return const Nothing(
                label: 'No Stories posted.',
              );
            }

            /// listing all stories
            return ListView.builder(
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                StoryModel story = state.stories[index];

                Widget leading;
                if (story.contentType == 'VIDEO') {
                  leading = CircleAvatar(
                    child: Thumbnail.network(
                      source: story.content.toString(),
                      isCircular: true,
                    ),
                  );
                } else {
                  leading = CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      story.content.toString(),
                    ),
                  );
                }

                /// showing each story in list tiles
                return ListTile(
                  onTap: () {
                    /// showing story according to index tapped
                    if (story.contentType == 'VIDEO') {
                      Navigator.pushNamed(context, Routes.webVideoViewer, arguments: {
                        'source': story.content.toString(),
                      });
                    } else {
                      Navigator.pushNamed(context, Routes.webImageViewer, arguments: {
                        'source': story.content.toString(),
                      });
                    }
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                      child: leading,
                    ),
                  ),
                  title: Text(story.contentType.toString().toLowerCase()),
                  subtitle: Text(story.postedOn.toString()),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      /// deleting story
                      BlocProvider.of<StoryBloc>(context).add(
                        DeleteStoryEvent(
                          stories: state.stories,
                          storyId: story.id.toString(),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const ListTileShimmerLoading();
        },
      ),
      bottomSheet: Card(
        elevation: 1,
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// for text story
              const Text(
                'Add New Story',
                style: TextStyle(fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                        child: const Icon(
                          Icons.text_fields_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    onTap: () {
                      _pickTextBg();
                    },
                  ),
                  const SizedBox(width: 20),

                  /// for image story
                  InkWell(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    onTap: () {
                      _pickImage();
                    },
                  ),
                  const SizedBox(width: 20),

                  /// for video story
                  InkWell(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: theme == ThemeState.light ? Colors.white : Colors.black,
                        child: const Icon(
                          Icons.videocam_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onTap: () {
                      _pickVideo();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
