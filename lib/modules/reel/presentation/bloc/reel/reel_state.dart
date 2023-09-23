import 'package:chatdrop/shared/models/reel_model/reel_model.dart';

abstract class ReelState {}

class ReelInitialState extends ReelState {}

class ReelPostingState extends ReelState {}
class ReelPostedState extends ReelState {}

class LoadingReelState extends ReelState {}

class ListReelState extends ReelState {
  final List<ReelModel> reels;

  ListReelState(this.reels);
}

class ReelFailedState extends ReelState {
  final String error;
  ReelFailedState(this.error);
}
