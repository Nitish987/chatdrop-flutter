import 'package:chatdrop/shared/models/user_model/user_model.dart';

abstract class FansState {}

class FansInitialState extends FansState {}

class LoadingFansState extends FansState {}

class ListFollowersState extends FansState {
  final List<UserModel> users;

  ListFollowersState(this.users);
}

class ListFollowingsState extends FansState {
  final List<UserModel> users;

  ListFollowingsState(this.users);
}

class FansFailedState extends FansState {
  final String error;

  FansFailedState(this.error);
}
