import 'package:chatdrop/shared/models/post_model/post_model.dart';

abstract class TimelineFeedState {}

class TimelineFeedInitialState extends TimelineFeedState {}

class FetchingTimelineFeedState extends TimelineFeedState {}
class FetchedTimelineFeedState extends TimelineFeedState {
  final List<PostModel> posts;
  final bool hasNext;
  FetchedTimelineFeedState({required this.posts, this.hasNext = false});
}
class TimelineFeedFailedState extends TimelineFeedState {}