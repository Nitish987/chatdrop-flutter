import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/feed_service.dart';
import 'reel_feed_event.dart';
import 'reel_feed_state.dart';

class ReelFeedBloc extends Bloc<ReelFeedEvent, ReelFeedState> {
  final FeedService _feedService = FeedService();
  final List<ReelModel> _reels = [];
  late bool _hasNext = false;

  ReelFeedBloc() : super(ReelFeedInitialState()) {
    fetchReelFeedEvent();
    moveReelFeedEvent();
  }

  void fetchReelFeedEvent() {
    on<FetchReelFeedEvent>((event, emit) async {
      Map<String, dynamic> result = await _feedService.fetchReelsFeeds(event.page);
      if (result['feeds'] != null) {
        if (event.page == 1) {
          _reels.clear();
        }
        _reels.addAll(result['feeds'] as List<ReelModel>);
      }
      _hasNext = result['has_next'] as bool;
      emit(FetchedReelFeedState(reels: _reels, hasNext: _hasNext));
    });
  }

  void moveReelFeedEvent() {
    on<MoveReelFeedEvent>((event, emit) async {
      int index = _reels.indexWhere((reel) => reel.id! == event.id);
      ReelModel model = _reels[index];
      _reels.removeAt(index);
      _reels.insert(0, model);
      emit(FetchedReelFeedState(reels: _reels, hasNext: _hasNext));
    });
  }
}