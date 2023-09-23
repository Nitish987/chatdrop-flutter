import 'package:chatdrop/modules/reel/presentation/bloc/reel/reel_event.dart';
import 'package:chatdrop/modules/reel/presentation/bloc/reel/reel_state.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelBloc extends Bloc<ReelEvent, ReelState> {
  final ReelService _reelService = ReelService();

  ReelBloc() : super(ReelInitialState()) {
    addReelEvent();
    listReelEvent();
  }

  void addReelEvent() {
    on<AddReelEvent>((event, emit) async {
      emit(ReelPostingState());
      bool result = await _reelService.addReel(event.visibility, event.hashtags, event.videoPath,event.thumbnailPath, event.aspectRatio,
        text: event.text,
        audioId: event.audioId,
      );
      if (result) {
        emit(ReelPostedState());
      } else {
        emit(ReelFailedState('Unable to post.'));
      }
    });
  }

  void listReelEvent() {
    on<ListReelEvent>((event, emit) async {
      emit(LoadingReelState());
      List<ReelModel>? reels = await _reelService.listReel(event.uid);
      if (reels != null) {
        emit(ListReelState(reels));
      } else {
        emit(ReelFailedState('Unable to load reels.'));
      }
    });
  }
}