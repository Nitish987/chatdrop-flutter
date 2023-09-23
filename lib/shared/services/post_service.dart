import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/post_comment_model/post_comment_model.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/repository/post_repo.dart';

class PostService {
  final PostRepository _postRepository = PostRepository.instance;

  Future<bool> addTextPost(String visibility, String hashtags, String text) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPost(visibility, 'TEXT', hashtags,  text: text),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPhotoPost(String visibility, String hashtags, List<String>? photosPath, List<double> aspectRatios) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPost(visibility, 'PHOTO', hashtags, photosPath: photosPath, photoAspectRatios: aspectRatios),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addVideoPost(String visibility, String hashtags, String videoPath, double aspectRatio, String thumbnailPath) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPost(visibility, 'VIDEO', hashtags, videoPath: videoPath, videoAspectRatio: aspectRatio, thumbnailPath: thumbnailPath),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTextPhotoPost(String visibility, String hashtags, String text, List<String>? photosPath, List<double> aspectRatios) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPost(visibility, 'TEXT_PHOTO', hashtags, text: text, photosPath: photosPath, photoAspectRatios: aspectRatios),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTextVideoPost(String visibility, String hashtags, String text, String videoPath, double aspectRatio, String thumbnailPath) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPost(visibility, 'TEXT_VIDEO', hashtags, text: text, videoPath: videoPath, videoAspectRatio: aspectRatio, thumbnailPath: thumbnailPath),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<PostModel?> viewPost(String postId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.viewPost(postId),
      );
      if (response.success) {
        final result = response.data?['post'];
        if (result != null) {
          PostModel post = PostModel.fromJson(result as Map<String, dynamic>);
          return post;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> changePostVisibility(String postId, String visibility) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.changePostVisibility(postId, visibility),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<List<PostModel>?> listPost(String uid, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.listPost(uid, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['posts'];
        List<PostModel> posts = result.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
        return posts;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.deletePost(postId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> likePost(String postId, String liked) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.likePost(postId, liked),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> dislikePost(String postId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.dislikePost(postId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<List<PostCommentModel>?> getPostComments(String postId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.getPostComments(postId),
      );
      if (response.success) {
        List<dynamic> result = response.data?['comments'];
        List<PostCommentModel> comments = result
            .map((e) => PostCommentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return comments;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<PostCommentModel?> addPostComment(String postId, String text) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.addPostComment(postId, text),
      );
      if (response.success) {
        PostCommentModel comment =
            PostCommentModel.fromJson(response.data?['comment']);
        return comment;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deletePostComment(String postId, String commentId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.deletePostComment(postId, commentId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> likePostComment(String commentId, String liked) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.likePostComment(commentId, liked),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> dislikePostComment(String commentId) async {
    try {
      final response = ResponseCollector.collect(
        await _postRepository.dislikePostComment(commentId),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
