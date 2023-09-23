import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/feed_service.dart';
import 'timeline_feed_event.dart';
import 'timeline_feed_state.dart';

class TimelineFeedBloc extends Bloc<TimelineFeedEvent, TimelineFeedState> {
  final FeedService _timelineFeedService = FeedService();
  final List<PostModel> _posts = [];

  TimelineFeedBloc() : super(TimelineFeedInitialState()) {
    fetchTimelineFeedEvent();
  }

  void fetchTimelineFeedEvent() {
    on<FetchTimelineFeedEvent>((event, emit) async {
      Map<String, dynamic> result = await _timelineFeedService.fetchTimelineFeeds(event.page);
      if (result['feeds'] != null) {
        if (event.page == 1) {
          _posts.clear();
        }
        _posts.addAll(result['feeds'] as List<PostModel>);
      }
      emit(FetchedTimelineFeedState(posts: _posts, hasNext: result['has_next'] as bool));
    });
  }
}