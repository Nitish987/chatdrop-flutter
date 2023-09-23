import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_event.dart';
import 'package:chatdrop/modules/privacy/presentation/bloc/blocked_user/blocked_user_state.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:chatdrop/modules/privacy/domain/services/privacy_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockedUserBloc extends Bloc<BlockedUserEvent, BlockedUserState> {
  final PrivacyService _privacyService = PrivacyService();

  BlockedUserBloc() : super(LoadingBlockUserList()) {
    fetchBlockUserList();
  }

  void fetchBlockUserList() {
    on<ListBlockedUserEvent>((event, emit) async {
      List<UserModel>? blockedUsers = await _privacyService.fetchBlockUserList();
      if (blockedUsers != null) {
        emit(BlockUserListState(blockedUsers));
      } else {
        emit(FailedBlockUserList('Unable to load blocked users.'));
      }
    });
  }
}