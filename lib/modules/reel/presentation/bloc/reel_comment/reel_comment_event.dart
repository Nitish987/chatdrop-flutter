import 'package:chatdrop/shared/models/reel_comment_model/reel_comment_model.dart';

abstract class ReelCommentEvent {}

class FetchReelCommentEvent extends ReelCommentEvent {
  String reelId;
  FetchReelCommentEvent(this.reelId);
}

class AddReelCommentEvent extends ReelCommentEvent {
  List<ReelCommentModel> comments;
  String reelId;
  String text;
  AddReelCommentEvent({required this.comments, required this.reelId, required this.text});
}