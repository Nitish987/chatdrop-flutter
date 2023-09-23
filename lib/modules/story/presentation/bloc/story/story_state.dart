import 'package:chatdrop/shared/models/story_model/story_model.dart';

abstract class StoryState {}

class StoryInitialState extends StoryState {}

class StoryListLoadingState extends StoryState {}
class StoryListedState extends StoryState {
  List<StoryModel> stories;
  StoryListedState(this.stories);
}

class StoryPostingState extends StoryState {}
class StoryAddedState extends StoryState {}

class DeletingStoryState extends StoryState {}
class DeletedStoryState extends StoryState {}

class StoryFailedState extends StoryState {
  final String error;
  StoryFailedState(this.error);
}
