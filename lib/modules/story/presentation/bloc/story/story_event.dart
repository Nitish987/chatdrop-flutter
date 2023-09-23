import 'package:chatdrop/shared/models/story_model/story_model.dart';

abstract class StoryEvent {}

class FetchStoriesEvent extends StoryEvent {}

class AddTextStoryEvent extends StoryEvent {
  final String imagePath;

  AddTextStoryEvent(this.imagePath);
}

class AddPhotoStoryEvent extends StoryEvent {
  final String imagePath;
  final String text;

  AddPhotoStoryEvent(this.imagePath, this.text);
}

class AddVideoStoryEvent extends StoryEvent {
  final String videoPath;
  final String text;

  AddVideoStoryEvent(this.videoPath, this.text);
}

class DeleteStoryEvent extends StoryEvent {
  List<StoryModel> stories;
  String storyId;
  DeleteStoryEvent({required this.stories, required this.storyId});
}