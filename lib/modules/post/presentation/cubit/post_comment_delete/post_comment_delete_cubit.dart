import 'package:chatdrop/modules/post/presentation/cubit/post_comment_delete/post_comment_delete_state.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCommentDeleteCubit extends Cubit<PostCommentDeleteState> {
  final PostService _postService = PostService();

  PostCommentDeleteCubit() : super(PostCommentDeleteInitialState());

  deletePostComment(String postId, String commentId) {
    _postService.deletePostComment(postId, commentId);
    emit(PostCommentDeletedState());
  }
}