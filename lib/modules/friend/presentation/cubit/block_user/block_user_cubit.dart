import 'package:chatdrop/modules/friend/presentation/cubit/block_user/block_user_state.dart';
import 'package:chatdrop/modules/privacy/domain/services/privacy_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockUserCubit extends Cubit<BlockUserState> {
  final PrivacyService _privacyService = PrivacyService();

  BlockUserCubit(bool initial) : super(BlockUserState.initial) {
    if(initial) {
      emit(BlockUserState.block);
    } else {
      emit(BlockUserState.unblock);
    }
  }

  void blockUser(String uid) async {
    final result = await _privacyService.blockUser(uid);
    if (result) {
      emit(BlockUserState.block);
    }
  }

  void unblockUser(String uid) async {
    final result = await _privacyService.unblockUser(uid);
    if (result) {
      emit(BlockUserState.unblock);
    }
  }
}