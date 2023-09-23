import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/models/friend_profile_model/friend_profile_model.dart';
import '../../../../../shared/services/friend_service.dart';
import 'friend_event.dart';
import 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendService _friendService = FriendService();

  FriendBloc() : super(FriendInitialState()) {
    fetchProfileEvent();
    sendFriendRequestEvent();
    unfriendEvent();
    acceptFriendRequestEvent();
    sendFollowRequestEvent();
    acceptFollowRequestEvent();
    unfollowEvent();
    listFriendsEvent();
  }

  void fetchProfileEvent() {
    on<FriendProfileFetchEvent>((event, emit) async {
      emit(FriendProfileLoadingState());
      FriendProfileModel? model = await _friendService.fetchProfile(event.uid);
      if (model == null) {
        emit(FriendProfileFailedState('Unable to Load Profile.'));
      } else {
        emit(FriendProfileSuccessState(model));
      }
    });
  }

  void sendFriendRequestEvent() {
    on<SendFriendRequestEvent>((event, emit) async {
      var result = await _friendService.sendFriendRequest(event.uid);
      if (result) {
        emit(FriendRequestSentState());
      } else {
        emit(FriendProfileFailedState('Unable to send friend request.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void unfriendEvent() {
    on<UnfriendEvent>((event, emit) async {
      var result = await _friendService.unfriend(event.uid);
      if (result) {
        event.friendProfile.isFriend = false;
        emit(FriendRemovedState());
      } else {
        emit(FriendProfileFailedState('Unable to unfriend.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void acceptFriendRequestEvent() {
    on<FriendRequestAcceptedEvent>((event, emit) async {
      var result = await _friendService.acceptRequest(event.requestId);
      if (result) {
        event.friendProfile.isFriend = true;
        emit(FriendRequestAcceptedState());
      } else {
        emit(FriendProfileFailedState('Unable to accept request.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void sendFollowRequestEvent() {
    on<SendFollowRequestEvent>((event, emit) async {
      var result = await _friendService.sendFollowRequest(event.uid);
      if (result) {
        emit(FriendFollowRequestSentState());
      } else {
        emit(FriendProfileFailedState('Unable to Follow.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void acceptFollowRequestEvent() {
    on<AcceptFollowRequestEvent>((event, emit) async {
      var result = await _friendService.acceptFollowRequest(event.requestId);
      if (result) {
        event.friendProfile.isFollowRequested = false;
        event.friendProfile.profile?.followingCount = event.friendProfile.profile?.followingCount ?? 0 + 1;
        emit(FriendFollowRequestAcceptedState());
      } else {
        emit(FriendProfileFailedState('Unable to Follow.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void unfollowEvent() {
    on<UnfollowFriendEvent>((event, emit) async {
      var result = await _friendService.unfollow(event.uid);
      if (result) {
        event.friendProfile.isFollowing = false;
        event.friendProfile.profile?.followerCount = event.friendProfile.profile?.followerCount ?? 0 - 1;
        emit(FriendUnfollowedState());
      } else {
        emit(FriendProfileFailedState('Unable to Unfollow.'));
      }
      emit(FriendProfileSuccessState(event.friendProfile));
    });
  }

  void listFriendsEvent() {
    on<FriendListEvent>((event, emit) async {
      emit(LoadingFriendListState());
      List<UserModel>? friends = await _friendService.listFriends(event.uid);
      if (friends != null) {
        emit(FriendListState(friends));
      } else {
        emit(FailedLoadingFriendListState('Unable to load friends.'));
      }
    });
  }
}
