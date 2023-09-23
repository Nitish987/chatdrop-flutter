import 'package:chatdrop/shared/models/user_model/user_model.dart';

abstract class MyFriendListState {}

class LoadingMyFriendListState extends MyFriendListState {}
class MyFriendListedState extends MyFriendListState {
  List<UserModel> friends;
  MyFriendListedState(this.friends);
}
