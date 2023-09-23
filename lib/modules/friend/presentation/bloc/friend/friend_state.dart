import 'package:chatdrop/shared/models/user_model/user_model.dart';

import '../../../../../shared/models/friend_profile_model/friend_profile_model.dart';

abstract class FriendState {}

class FriendInitialState extends FriendState {}

class FriendProfileLoadingState extends FriendState {}
class FriendProfileSuccessState extends FriendState {
  final FriendProfileModel profileModel;
  FriendProfileSuccessState(this.profileModel);
}
class FriendProfileFailedState extends FriendState {
  final String error;
  FriendProfileFailedState(this.error);
}

class FriendRequestSentState extends FriendState {}

class FriendRequestAcceptedState extends FriendState {}

class FriendRemovedState extends FriendState {}

class FriendFollowRequestSentState extends FriendState {}

class FriendFollowRequestAcceptedState extends FriendState {}

class FriendUnfollowedState extends FriendState {}

class LoadingFriendListState extends FriendState {}

class FriendListState extends FriendState {
  final List<UserModel> friends;

  FriendListState(this.friends);
}

class FailedLoadingFriendListState extends FriendState {
  final String error;
  FailedLoadingFriendListState(this.error);
}
