import 'package:chatdrop/shared/cubit/post_delete/post_delete_state.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDeleteCubit extends Cubit<PostDeleteState> {
  final PostService _postService = PostService();

  PostDeleteCubit() : super(PostDeleteInitialState());

  deletePost(String postId) {
    _postService.deletePost(postId);
    changeToPostDeletedState();
  }

  changeToPostDeletedState() {
    emit(PostDeletedState());
  }
}