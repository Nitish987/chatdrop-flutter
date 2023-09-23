import 'package:chatdrop/shared/cubit/post_visibility/post_visibility_state.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostVisibilityCubit extends Cubit<PostVisibilityState> {
  final PostService _postService = PostService();

  PostVisibilityCubit(String visibility) : super (PostVisibilityState.public) {
    emitState(visibility);
  }

  void changeVisibility(String id, String visibility) {
    _postService.changePostVisibility(id, visibility);
    emitState(visibility);
  }

  void emitState(String visibility) {
    switch (visibility) {
      case 'PUBLIC': emit(PostVisibilityState.public); break;
      case 'ONLY_FRIENDS': emit(PostVisibilityState.onlyFriends); break;
      case 'PRIVATE': emit(PostVisibilityState.private); break;
    }
  }
}