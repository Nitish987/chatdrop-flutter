abstract class ReelLikeState {}

class ReelLikeInitialState extends ReelLikeState {}

class ReelLikedState extends ReelLikeState {
  String type;
  ReelLikedState(this.type);
}

class ReelDislikedState extends ReelLikeState {}