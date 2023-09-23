import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reel_delete_state.dart';

class ReelDeleteCubit extends Cubit<ReelDeleteState> {
  final ReelService _reelService = ReelService();

  ReelDeleteCubit() : super(ReelDeleteInitialState());

  deleteReel(String postId) {
    _reelService.deleteReel(postId);
    changeToReelDeletedState();
  }

  changeToReelDeletedState() {
    emit(ReelDeletedState());
  }
}