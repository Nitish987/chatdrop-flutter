import 'package:chatdrop/shared/models/story_feed_model/story_feed_model.dart';

abstract class StoryFeedState {}

class StoryFeedInitialState extends StoryFeedState {}

class FetchingStoryFeedState extends StoryFeedState {}
class FetchedStoryFeedState extends StoryFeedState {
  final List<StoryFeedModel> storyFeeds;
  FetchedStoryFeedState(this.storyFeeds);
}
class StoryFeedFailedState extends StoryFeedState {}