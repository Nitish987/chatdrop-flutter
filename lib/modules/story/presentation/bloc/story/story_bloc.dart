import 'package:chatdrop/modules/story/presentation/bloc/story/story_event.dart';
import 'package:chatdrop/modules/story/presentation/bloc/story/story_state.dart';
import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/modules/story/domain/services/story_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryService _storyService = StoryService();

  StoryBloc() : super(StoryInitialState()) {
    fetchStoriesEvent();
    textStoryEvent();
    photoStoryEvent();
    videoStoryEvent();
    deleteStoryEvent();
  }

  void fetchStoriesEvent() {
    on<FetchStoriesEvent>((event, emit) async {
      emit(StoryListLoadingState());
      List<StoryModel>? stories = await _storyService.listStory();
      if (stories != null) {
        emit(StoryListedState(stories));
      } else {
        emit(StoryFailedState('Unable to load Stories.'));
      }
    });
  }

  void textStoryEvent() {
    on<AddTextStoryEvent>((event, emit) async {
      emit(StoryPostingState());
      bool result = await _storyService.addTextStory(event.imagePath);
      if (result) {
        emit(StoryAddedState());
      } else {
        emit(StoryFailedState('Unable to post story.'));
      }
    });
  }

  void photoStoryEvent() {
    on<AddPhotoStoryEvent>((event, emit) async {
      emit(StoryPostingState());
      bool result = await _storyService.addPhotoStory(event.imagePath, event.text);
      if (result) {
        emit(StoryAddedState());
      } else {
        emit(StoryFailedState('Unable to post story.'));
      }
    });
  }

  void videoStoryEvent() {
    on<AddVideoStoryEvent>((event, emit) async {
      emit(StoryPostingState());
      bool result = await _storyService.addVideoStory(event.videoPath, event.text);
      if (result) {
        emit(StoryAddedState());
      } else {
        emit(StoryFailedState('Unable to post story.'));
      }
    });
  }

  void deleteStoryEvent() {
    on<DeleteStoryEvent>((event, emit) async {
      emit(DeletingStoryState());
      bool result = await _storyService.deleteStory(event.storyId);
      if (result) {
        event.stories = event.stories.where((element) => element.id != event.storyId.toString()).toList();
        emit(DeletedStoryState());
      } else {
        emit(StoryFailedState('Unable to delete story.'));
      }
      emit(StoryListedState(event.stories));
    });
  }
}