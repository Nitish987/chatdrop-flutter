import 'package:chatdrop/shared/models/post_comment_model/post_comment_model.dart';

abstract class PostCommentEvent {}

class FetchPostCommentEvent extends PostCommentEvent {
  String postId;
  FetchPostCommentEvent(this.postId);
}

class AddPostCommentEvent extends PostCommentEvent {
  List<PostCommentModel> comments;
  String postId;
  String text;
  AddPostCommentEvent({required this.comments, required this.postId, required this.text});
}