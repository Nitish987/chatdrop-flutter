import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdrop/shared/cubit/theme/theme_cubit.dart';
import 'package:chatdrop/shared/cubit/theme/theme_state.dart';
import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/shared/widgets/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Story extends StatelessWidget {
  const Story(
      {Key? key,
      required this.stories,
      required this.onStoryTap,
      required this.onAddTap})
      : super(key: key);

  final List<StoryModel> stories;
  final Function onStoryTap;
  final Function onAddTap;

  @override
  Widget build(BuildContext context) {
    ThemeState theme = BlocProvider.of<ThemeCubit>(context).state;
    Widget storyThumbnail;

    if (stories.isEmpty) {
      storyThumbnail = CircleAvatar(
        radius: 27,
        backgroundColor: Colors.blue.shade100,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.blue,
          ),
          onPressed: () {
            onAddTap();
          },
        ),
      );
    } else {
      /// Getting current story posted for thumbnail
      StoryModel story = stories.last;

      /// Creating Story Thumbnail
      if (story.contentType == 'VIDEO') {
        storyThumbnail = CircleAvatar(
          radius: 27,
          child: Thumbnail.network(
            source: story.content.toString(),
            isCircular: true,
          ),
        );
      } else {
        storyThumbnail = CircleAvatar(
          radius: 27,
          backgroundImage: CachedNetworkImageProvider(
            story.content.toString(),
          ),
        );
      }
    }

    /// Story in Circular Avatar
    return InkWell(
      onTap: () {
        if (stories.isNotEmpty) {
          onStoryTap();
        }
      },
      child: CircleAvatar(
        radius: 33,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: theme == ThemeState.light ? Colors.white: Colors.black,
          child: storyThumbnail,
        ),
      ),
    );
  }
}
