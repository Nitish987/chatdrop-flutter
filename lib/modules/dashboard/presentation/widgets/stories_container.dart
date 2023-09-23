import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/models/story_feed_model/story_feed_model.dart';
import 'package:chatdrop/modules/dashboard/presentation/widgets/story_feed_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/story_feed/story_feed_bloc.dart';
import '../../../../shared/bloc/story_feed/story_feed_state.dart';
import 'story.dart';

class StoriesContainer extends StatelessWidget {
  const StoriesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      height: 86,
      child: BlocBuilder<StoryFeedBloc, StoryFeedState>(
        builder: (context, state) {
          if (state is FetchedStoryFeedState) {
            List<StoryFeedModel> storyFeeds = state.storyFeeds;

            /// Listing Stories
            return ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: storyFeeds.length,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 5);
              },
              itemBuilder: (context, index) {
                return Story(
                  key: Key(storyFeeds[index].user!.uid.toString()),
                  stories: storyFeeds[index].stories!,
                  onStoryTap: () {
                    /// Story Showcase Button
                    Navigator.pushNamed(
                      context,
                      Routes.storyShowcase,
                      arguments: {
                        'story': storyFeeds[index],
                      },
                    );
                  },
                  onAddTap: () {
                    /// Add Story Button
                    Navigator.pushNamed(context, Routes.storyConfig);
                  },
                );
              },
            );
          }
          return const StoryFeedShimmerLoading();
        },
      ),
    );
  }
}
