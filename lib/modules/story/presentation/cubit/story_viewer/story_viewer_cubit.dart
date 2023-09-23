import 'package:chatdrop/modules/story/domain/services/story_service.dart';
import 'package:chatdrop/modules/story/presentation/cubit/story_viewer/story_viewer_state.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryViewerCubit extends Cubit<StoryViewerState> {
  final StoryService _storyService = StoryService();

  StoryViewerCubit(String storyId) : super(LoadingStoryViewersState()) {
    fetchStoryViewers(storyId);
  }

  void fetchStoryViewers(String storyId) async {
    emit(LoadingStoryViewersState());
    List<UserModel>? viewers = await _storyService.listStoryViewers(storyId);
    if (viewers == null) {
      emit(StoryViewersListedState([]));
    } else {
      emit(StoryViewersListedState(viewers));
    }
  }
}