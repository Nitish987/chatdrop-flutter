import 'package:chatdrop/modules/post/presentation/cubit/post_comment_like/post_comment_like_state.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCommentLikeCubit extends Cubit<PostCommentLikeState> {
  final PostService _postService = PostService();

  PostCommentLikeCubit(String? liked) : super(PostCommentLikeInitialState()) {
    if (liked != null) {
      emit(PostCommentLikedState(liked));
    }
  }

  likePostComment(String commentId, String liked) {
    _postService.likePostComment(commentId ,liked);
    emit(PostCommentLikedState(liked));
  }

  dislikePostComment(String commentId) {
    _postService.dislikePostComment(commentId);
    emit(PostCommentDislikedState());
  }
}