import 'package:chatdrop/shared/models/post_model/post_model.dart';

abstract class PostState {}

class PostInitialState extends PostState {}

class PostingState extends PostState {}
class PostedState extends PostState {}

class LoadingPostState extends PostState {}

class ListPostState extends PostState {
  final List<PostModel> posts;

  ListPostState(this.posts);
}

class PostFailedState extends PostState {
  final String error;
  PostFailedState(this.error);
}
