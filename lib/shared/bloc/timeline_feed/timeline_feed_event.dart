abstract class TimelineFeedEvent {}

class FetchTimelineFeedEvent extends TimelineFeedEvent {
  final int page;
  FetchTimelineFeedEvent({this.page = 1});
}