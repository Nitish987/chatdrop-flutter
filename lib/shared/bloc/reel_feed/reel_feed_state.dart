import 'package:chatdrop/shared/models/reel_model/reel_model.dart';

abstract class ReelFeedState {}

class ReelFeedInitialState extends ReelFeedState {}

class FetchingReelFeedState extends ReelFeedState {}
class FetchedReelFeedState extends ReelFeedState {
  final List<ReelModel> reels;
  final bool hasNext;
  FetchedReelFeedState({required this.reels, this.hasNext = false});
}
class ReelFeedFailedState extends ReelFeedState {}