abstract class ReelCommentLikeState {}

class ReelCommentLikeInitialState extends ReelCommentLikeState {}

class ReelCommentLikedState extends ReelCommentLikeState {
  String type;
  ReelCommentLikedState(this.type);
}

class ReelCommentDislikedState extends ReelCommentLikeState {}