import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/services/fans_service.dart';
import 'fans_event.dart';
import 'fans_state.dart';

class FansBloc extends Bloc<FansEvent, FansState> {
  final FansService _fansService = FansService();

  FansBloc() : super(FansInitialState()) {
    listFollowersEvent();
    listFollowingsEvent();
  }

  void listFollowersEvent() {
    on<FetchFollowersEvent>((event, emit) async {
      emit(LoadingFansState());
      List<UserModel>? users = await _fansService.listFollowers(event.uid);
      if (users != null) {
        emit(ListFollowersState(users));
      } else {
        emit(FansFailedState('Unable to load followers.'));
      }
    });
  }

  void listFollowingsEvent() {
    on<FetchFollowingsEvent>((event, emit) async {
      emit(LoadingFansState());
      List<UserModel>? users = await _fansService.listFollowings(event.uid);
      if (users != null) {
        emit(ListFollowingsState(users));
      } else {
        emit(FansFailedState('Unable to load followings.'));
      }
    });
  }
}