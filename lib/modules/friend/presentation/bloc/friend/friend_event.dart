import '../../../../../shared/models/friend_profile_model/friend_profile_model.dart';

abstract class FriendEvent {}

class FriendProfileFetchEvent extends FriendEvent {
  final String uid;
  FriendProfileFetchEvent(this.uid);
}

class SendFriendRequestEvent extends FriendEvent {
  final String uid;
  final FriendProfileModel friendProfile;
  SendFriendRequestEvent({required this.uid, required this.friendProfile});
}

class FriendRequestAcceptedEvent extends FriendEvent {
  final int requestId;
  final FriendProfileModel friendProfile;
  FriendRequestAcceptedEvent({required this.requestId, required this.friendProfile});
}

class UnfriendEvent extends FriendEvent {
  final String uid;
  final FriendProfileModel friendProfile;
  UnfriendEvent({required this.uid, required this.friendProfile});
}

class SendFollowRequestEvent extends FriendEvent {
  final String uid;
  final FriendProfileModel friendProfile;
  SendFollowRequestEvent({required this.uid, required this.friendProfile});
}

class AcceptFollowRequestEvent extends FriendEvent {
  final int requestId;
  final FriendProfileModel friendProfile;
  AcceptFollowRequestEvent({required this.requestId, required this.friendProfile});
}

class UnfollowFriendEvent extends FriendEvent {
  final String uid;
  final FriendProfileModel friendProfile;
  UnfollowFriendEvent({required this.uid, required this.friendProfile});
}

class FriendListEvent extends FriendEvent {
  final String uid;

  FriendListEvent(this.uid);
}

class MyFriendListEvent extends FriendEvent {}