abstract class ReelFeedEvent {}

class FetchReelFeedEvent extends ReelFeedEvent {
  final int page;
  FetchReelFeedEvent({this.page = 1});
}

class MoveReelFeedEvent extends ReelFeedEvent {
  final String id;
  MoveReelFeedEvent(this.id);
}