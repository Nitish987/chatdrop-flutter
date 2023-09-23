import 'package:chatdrop/modules/reel/presentation/bloc/reel_comment/reel_comment_event.dart';
import 'package:chatdrop/modules/reel/presentation/bloc/reel_comment/reel_comment_state.dart';
import 'package:chatdrop/shared/models/reel_comment_model/reel_comment_model.dart';
import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelCommentBloc extends Bloc<ReelCommentEvent, ReelCommentState> {
  final ReelService _reelService = ReelService();

  ReelCommentBloc() : super(ReelCommentInitialState()) {
    fetchReelCommentEvent();
    addReelCommentEvent();
  }

  void fetchReelCommentEvent() {
    on<FetchReelCommentEvent>((event, emit) async {
      emit(FetchingReelCommentState());
      List<ReelCommentModel>? comments =
      await _reelService.getReelComments(event.reelId);
      if (comments != null) {
        emit(FetchedReelCommentState(comments));
      } else {
        emit(ReelCommentFailedState('Unable to load comments.'));
      }
    });
  }

  void addReelCommentEvent() {
    on<AddReelCommentEvent>((event, emit) async {
      if (event.text.isNotEmpty) {
        ReelCommentModel? comment = await _reelService.addReelComment(
          event.reelId,
          event.text,
        );
        if (comment != null) {
          event.comments.add(comment);
          emit(FetchedReelCommentState(event.comments));
        }
      }
    });
  }
}
