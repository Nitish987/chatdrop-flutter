import 'package:chatdrop/shared/cubit/reel_visibility/reel_visibility_state.dart';
import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelVisibilityCubit extends Cubit<ReelVisibilityState> {
  final ReelService _reelService = ReelService();

  ReelVisibilityCubit(String visibility) : super (ReelVisibilityState.public) {
    emitState(visibility);
  }

  void changeVisibility(String id, String visibility) {
    _reelService.changeReelVisibility(id, visibility);
    emitState(visibility);
  }

  void emitState(String visibility) {
    switch (visibility) {
      case 'PUBLIC': emit(ReelVisibilityState.public); break;
      case 'ONLY_FRIENDS': emit(ReelVisibilityState.onlyFriends); break;
      case 'PRIVATE': emit(ReelVisibilityState.private); break;
    }
  }
}