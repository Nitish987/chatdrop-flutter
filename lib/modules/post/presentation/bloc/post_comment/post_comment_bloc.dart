import 'package:chatdrop/modules/post/presentation/bloc/post_comment/post_comment_event.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post_comment/post_comment_state.dart';
import 'package:chatdrop/shared/models/post_comment_model/post_comment_model.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  final PostService _postService = PostService();

  PostCommentBloc() : super(PostCommentInitialState()) {
    fetchPostCommentEvent();
    addPostCommentEvent();
  }

  void fetchPostCommentEvent() {
    on<FetchPostCommentEvent>((event, emit) async {
      emit(FetchingPostCommentState());
      List<PostCommentModel>? comments =
          await _postService.getPostComments(event.postId);
      if (comments != null) {
        emit(FetchedPostCommentState(comments));
      } else {
        emit(PostCommentFailedState('Unable to load comments.'));
      }
    });
  }

  void addPostCommentEvent() {
    on<AddPostCommentEvent>((event, emit) async {
      if (event.text.isNotEmpty) {
        PostCommentModel? comment = await _postService.addPostComment(
          event.postId,
          event.text,
        );
        if (comment != null) {
          event.comments.add(comment);
          emit(FetchedPostCommentState(event.comments));
        }
      }
    });
  }
}
