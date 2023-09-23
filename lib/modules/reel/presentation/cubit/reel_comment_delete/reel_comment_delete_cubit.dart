import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reel_comment_delete_state.dart';

class ReelCommentDeleteCubit extends Cubit<ReelCommentDeleteState> {
  final ReelService _reelService = ReelService();

  ReelCommentDeleteCubit() : super(ReelCommentDeleteInitialState());

  deleteReelComment(String postId, String commentId) {
    _reelService.deleteReelComment(postId, commentId);
    emit(ReelCommentDeletedState());
  }
}