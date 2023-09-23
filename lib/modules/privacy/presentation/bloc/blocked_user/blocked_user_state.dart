import 'package:chatdrop/shared/models/user_model/user_model.dart';

abstract class BlockedUserState {}

class LoadingBlockUserList extends BlockedUserState {}

class BlockUserListState extends BlockedUserState {
  List<UserModel> blockedUsers;
  BlockUserListState(this.blockedUsers);
}

class FailedBlockUserList extends BlockedUserState {
  String error;
  FailedBlockUserList(this.error);
}