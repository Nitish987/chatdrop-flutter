import 'package:chatdrop/shared/models/story_feed_model/story_feed_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/feed_service.dart';
import 'story_feed_event.dart';
import 'story_feed_state.dart';

class StoryFeedBloc extends Bloc<StoryFeedEvent, StoryFeedState> {
  final FeedService _storyFeedService = FeedService();

  StoryFeedBloc() : super(StoryFeedInitialState()) {
    fetchStoryFeedEvent();
  }

  void fetchStoryFeedEvent() {
    on<FetchStoryFeedEvent>((event, emit) async {
      emit(FetchingStoryFeedState());
      List<StoryFeedModel>? storyFeeds = await _storyFeedService.fetchStoryFeeds();
      emit(FetchedStoryFeedState(storyFeeds ?? []));
    });
  }
}