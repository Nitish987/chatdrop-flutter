abstract class FansEvent {}

class FetchFollowersEvent extends FansEvent {
  final String uid;

  FetchFollowersEvent(this.uid);
}
class FetchFollowingsEvent extends FansEvent {
  final String uid;

  FetchFollowingsEvent(this.uid);
}