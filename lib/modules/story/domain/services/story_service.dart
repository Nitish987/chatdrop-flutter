import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/story_model/story_model.dart';
import 'package:chatdrop/modules/story/data/repository/story_repo.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';

class StoryService {
  final StoryRepository _storyRepository = StoryRepository.instance;

  Future<bool> addTextStory(imagePath) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.addStory(
          'TEXT',
          imagePath: imagePath,
        ),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPhotoStory(imagePath, text) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.addStory(
          'PHOTO',
          imagePath: imagePath,
          text: text,
        ),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addVideoStory(videoPath, text) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.addStory(
          'VIDEO',
          videoPath: videoPath,
          text: text,
        ),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<List<StoryModel>?> listStory() async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.listStory(),
      );
      if (response.success) {
        List<dynamic> result = response.data?['stories'];
        List<StoryModel> stories = result.map((e) => StoryModel.fromJson(e as Map<String, dynamic>)).toList();
        return stories;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<bool> deleteStory(storyId) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.deleteStory(storyId),
      );
      return response.success;
    } catch(e) {
      return false;
    }
  }

  Future<bool> giveStoryView(storyId) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.addStoryView(storyId),
      );
      return response.success;
    } catch(e) {
      return false;
    }
  }

  Future<List<UserModel>?> listStoryViewers(storyId) async {
    try {
      final response = ResponseCollector.collect(
        await _storyRepository.listStoryViewers(storyId),
      );
      if (response.success) {
        List<dynamic> result = response.data?['viewers'];
        List<UserModel> users = result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return users;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }
}
