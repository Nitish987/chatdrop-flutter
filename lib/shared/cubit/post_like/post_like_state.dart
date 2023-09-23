abstract class PostLikeState {}

class PostLikeInitialState extends PostLikeState {}

class PostLikedState extends PostLikeState {
  String type;
  PostLikedState(this.type);
}

class PostDislikedState extends PostLikeState {}