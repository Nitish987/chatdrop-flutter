import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/models/reel_model/reel_model.dart';
import 'package:chatdrop/shared/repository/reel_repo.dart';

import '../models/reel_comment_model/reel_comment_model.dart';

class ReelService {
  final ReelRepository _reelRepository = ReelRepository.instance;

  Future<bool> addReel(String visibility, String hashtags, String videoPath, String thumbnailPath, double aspectRatio, {String text = '', int audioId = 0}) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.addReel(visibility, hashtags, videoPath, thumbnailPath, aspectRatio, text: text, audioId: audioId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> giveReelView(String reelId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.addReelView(reelId),
      );
      return response.success;
    } catch(e) {
      return false;
    }
  }

  Future<ReelModel?> viewReel(String reelId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.viewReel(reelId),
      );
      if (response.success) {
        final result = response.data?['reel'];
        if (result != null) {
          ReelModel reel = ReelModel.fromJson(result as Map<String, dynamic>);
          return reel;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> changeReelVisibility(String reelId, String visibility) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.changeReelVisibility(reelId, visibility),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<List<ReelModel>?> listReel(String uid, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.listReel(uid, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['reels'];
        List<ReelModel> reels = result.map((e) => ReelModel.fromJson(e as Map<String, dynamic>)).toList();
        return reels;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteReel(String reelId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.deleteReel(reelId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> likeReel(String reelId, String liked) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.likeReel(reelId, liked),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> dislikeReel(String reelId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.dislikeReel(reelId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<List<ReelCommentModel>?> getReelComments(String reelId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.getReelComments(reelId),
      );
      if (response.success) {
        List<dynamic> result = response.data?['comments'];
        List<ReelCommentModel> comments = result
            .map((e) => ReelCommentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return comments;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ReelCommentModel?> addReelComment(String reelId, String text) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.addReelComment(reelId, text),
      );
      if (response.success) {
        ReelCommentModel comment =
        ReelCommentModel.fromJson(response.data?['comment']);
        return comment;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteReelComment(String reelId, String commentId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.deleteReelComment(reelId, commentId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> likeReelComment(String commentId, String liked) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.likeReelComment(commentId, liked),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> dislikeReelComment(String commentId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.dislikeReelComment(commentId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<AudioModel?> addAudio(String name, String audioPath, int duration) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.addAudio(name, audioPath, duration),
      );
      if (response.success) {
        AudioModel audio = AudioModel.fromJson(response.data?['audio'] as Map<String, dynamic>);
        return audio;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<AudioModel>> listAudio() async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.listAudio(),
      );
      if (response.success) {
        List<dynamic> result = response.data?['audios'];
        List<AudioModel> audios = result.map((e) => AudioModel.fromJson(e as Map<String, dynamic>)).toList();
        return audios;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteAudio(int audioId) async {
    try {
      final response = ResponseCollector.collect(
        await _reelRepository.deleteAudio(audioId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
