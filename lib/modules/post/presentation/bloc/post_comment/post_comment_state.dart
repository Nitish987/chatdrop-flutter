import 'package:chatdrop/shared/models/post_comment_model/post_comment_model.dart';

abstract class PostCommentState {}

class PostCommentInitialState extends PostCommentState {}

class FetchingPostCommentState extends PostCommentState {}
class FetchedPostCommentState extends PostCommentState {
  List<PostCommentModel> comments;
  FetchedPostCommentState(this.comments);
}

class PostCommentFailedState extends PostCommentState {
  String error;
  PostCommentFailedState(this.error);
}