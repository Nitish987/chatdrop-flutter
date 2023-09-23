import 'package:chatdrop/shared/models/reel_model/reel_model.dart';

import '../../infra/utilities/response.dart';
import '../models/post_model/post_model.dart';
import '../models/story_feed_model/story_feed_model.dart';
import '../repository/feed_repo.dart';

class FeedService {
  final FeedRepository _feedRepository = FeedRepository.instance;

  Future<Map<String, dynamic>> fetchTimelineFeeds(int page) async {
    try {
      final response = ResponseCollector.collect(
        await _feedRepository.getTimelineFeeds(page: page),
      );
      if (response.success) {
        List<dynamic> feeds = response.data?['feeds'];
        bool hasNext = response.data?['has_next'];
        List<PostModel> postFeeds = feeds.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
        return {
          'feeds': postFeeds,
          'has_next': hasNext,
        };
      }
      return {
        'feeds': null,
        'has_next': false,
      };
    } catch (e) {
      return {
        'feeds': null,
        'has_next': false,
      };
    }
  }

  Future<List<StoryFeedModel>?> fetchStoryFeeds() async {
    try {
      final response = ResponseCollector.collect(
        await _feedRepository.getStoryFeeds(),
      );
      if (response.success) {
        List<dynamic> feeds = response.data?['feeds'];
        List<StoryFeedModel> storyFeeds = feeds.map((e) => StoryFeedModel.fromJson(e as Map<String, dynamic>)).toList();
        return storyFeeds;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchReelsFeeds(int page) async {
    try {
      final response = ResponseCollector.collect(
        await _feedRepository.getReelsFeeds(page: page),
      );
      if (response.success) {
        List<dynamic> feeds = response.data?['feeds'];
        bool hasNext = response.data?['has_next'];
        List<ReelModel> reelFeeds = feeds.map((e) => ReelModel.fromJson(e as Map<String, dynamic>)).toList();
        return {
          'feeds': reelFeeds,
          'has_next': hasNext,
        };
      }
      return {
        'feeds': null,
        'has_next': false,
      };
    } catch (e) {
      return {
        'feeds': null,
        'has_next': false,
      };
    }
  }
}