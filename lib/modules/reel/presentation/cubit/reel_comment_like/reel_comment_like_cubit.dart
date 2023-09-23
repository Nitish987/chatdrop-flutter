import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reel_comment_like_state.dart';

class ReelCommentLikeCubit extends Cubit<ReelCommentLikeState> {
  final ReelService _reelService = ReelService();

  ReelCommentLikeCubit(String? liked) : super(ReelCommentLikeInitialState()) {
    if (liked != null) {
      emit(ReelCommentLikedState(liked));
    }
  }

  likeReelComment(String commentId, String liked) {
    _reelService.likeReelComment(commentId ,liked);
    emit(ReelCommentLikedState(liked));
  }

  dislikeReelComment(String commentId) {
    _reelService.dislikeReelComment(commentId);
    emit(ReelCommentDislikedState());
  }
}