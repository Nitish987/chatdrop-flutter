import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_like_state.dart';

class PostLikeCubit extends Cubit<PostLikeState> {
  final PostService _postService = PostService();

  PostLikeCubit(String? liked) : super(PostLikeInitialState()) {
    if (liked != null) {
      emit(PostLikedState(liked));
    }
  }

  likePost(String postId, String liked) {
    _postService.likePost(postId ,liked);
    emit(PostLikedState(liked));
  }

  dislikePost(String postId) {
    _postService.dislikePost(postId);
    emit(PostDislikedState());
  }
}