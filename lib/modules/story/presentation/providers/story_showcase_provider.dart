import 'package:chatdrop/modules/story/domain/services/story_service.dart';
import 'package:flutter/cupertino.dart';

class StoryShowcaseProvider extends ChangeNotifier {
  final StoryService _storyService = StoryService();

  String? storyId;
  int? storyIndex = 0;

  void setStoryId(String storyId, int storyIndex) {
    this.storyId = storyId;
    this.storyIndex = storyIndex;
    notifyListeners();
  }

  void giveStoryView() async {
    _storyService.giveStoryView(storyId);
  }
}