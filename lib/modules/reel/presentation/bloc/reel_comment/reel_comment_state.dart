import 'package:chatdrop/shared/models/reel_comment_model/reel_comment_model.dart';

abstract class ReelCommentState {}

class ReelCommentInitialState extends ReelCommentState {}

class FetchingReelCommentState extends ReelCommentState {}
class FetchedReelCommentState extends ReelCommentState {
  List<ReelCommentModel> comments;
  FetchedReelCommentState(this.comments);
}

class ReelCommentFailedState extends ReelCommentState {
  String error;
  ReelCommentFailedState(this.error);
}