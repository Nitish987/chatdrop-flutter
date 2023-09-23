import 'package:chatdrop/shared/models/user_model/user_model.dart';

abstract class StoryViewerState {}

class LoadingStoryViewersState extends StoryViewerState {}
class StoryViewersListedState extends StoryViewerState {
  final List<UserModel> viewers;
  StoryViewersListedState(this.viewers);
}