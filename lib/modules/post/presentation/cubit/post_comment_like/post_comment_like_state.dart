abstract class PostCommentLikeState {}

class PostCommentLikeInitialState extends PostCommentLikeState {}

class PostCommentLikedState extends PostCommentLikeState {
  String type;
  PostCommentLikedState(this.type);
}

class PostCommentDislikedState extends PostCommentLikeState {}