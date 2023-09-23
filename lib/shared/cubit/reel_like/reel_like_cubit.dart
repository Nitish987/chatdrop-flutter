import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reel_like_state.dart';

class ReelLikeCubit extends Cubit<ReelLikeState> {
  final ReelService _reelService = ReelService();

  ReelLikeCubit(String? liked) : super(ReelLikeInitialState()) {
    if (liked != null) {
      emit(ReelLikedState(liked));
    }
  }

  likeReel(String reelId, String liked) {
    _reelService.likeReel(reelId ,liked);
    emit(ReelLikedState(liked));
  }

  dislikeReel(String reelId) {
    _reelService.dislikeReel(reelId);
    emit(ReelDislikedState());
  }
}