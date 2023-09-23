import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/shared/services/friend_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_friend_list_state.dart';

class MyFriendListCubit extends Cubit<MyFriendListState> {
  final FriendService _friendService = FriendService();

  MyFriendListCubit() : super(LoadingMyFriendListState()) {
    fetchMyFriendList();
  }

  void fetchMyFriendList() async {
    List<UserModel>? friends = await _friendService.listMyFriends();
    if (friends != null) {
      emit(MyFriendListedState(friends));
    } else {
      emit(MyFriendListedState([]));
    }
  }
}
