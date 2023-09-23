import 'package:chatdrop/modules/post/presentation/bloc/post/post_event.dart';
import 'package:chatdrop/modules/post/presentation/bloc/post/post_state.dart';
import 'package:chatdrop/shared/models/post_model/post_model.dart';
import 'package:chatdrop/shared/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService _postService = PostService();

  PostBloc() : super(PostInitialState()) {
    textPostEvent();
    photoPostEvent();
    videoPostEvent();
    textPhotoPostEvent();
    textVideoPostEvent();
    listPostEvent();
  }

  void textPostEvent() {
    on<AddTextPostEvent>((event, emit) async {
      emit(PostingState());
      bool result = await _postService.addTextPost(event.visibility, event.hashtags, event.text);
      if (result) {
        emit(PostedState());
      } else {
        emit(PostFailedState('Unable to post.'));
      }
    });
  }

  void photoPostEvent() {
    on<AddPhotoPostEvent>((event, emit) async {
      emit(PostingState());
      bool result = await _postService.addPhotoPost(event.visibility, event.hashtags, event.photosPath, event.aspectRatios);
      if (result) {
        emit(PostedState());
      } else {
        emit(PostFailedState('Unable to post.'));
      }
    });
  }

  void videoPostEvent() {
    on<AddVideoPostEvent>((event, emit) async {
      emit(PostingState());
      bool result = await _postService.addVideoPost(event.visibility, event.hashtags, event.videoPath, event.aspectRatio, event.thumbnailPath);
      if (result) {
        emit(PostedState());
      } else {
        emit(PostFailedState('Unable to post.'));
      }
    });
  }

  void textPhotoPostEvent() {
    on<AddTextPhotoPostEvent>((event, emit) async {
      emit(PostingState());
      bool result = await _postService.addTextPhotoPost(event.visibility, event.hashtags, event.text, event.photosPath, event.aspectRatios);
      if (result) {
        emit(PostedState());
      } else {
        emit(PostFailedState('Unable to post.'));
      }
    });
  }

  void textVideoPostEvent() {
    on<AddTextVideoPostEvent>((event, emit) async {
      emit(PostingState());
      bool result = await _postService.addTextVideoPost(event.visibility, event.hashtags, event.text, event.videoPath, event.aspectRatio, event.thumbnailPath);
      if (result) {
        emit(PostedState());
      } else {
        emit(PostFailedState('Unable to post.'));
      }
    });
  }

  void listPostEvent() {
    on<ListPostEvent>((event, emit) async {
      emit(LoadingPostState());
      List<PostModel>? posts = await _postService.listPost(event.uid);
      if (posts != null) {
        emit(ListPostState(posts));
      } else {
        emit(PostFailedState('Unable to load posts.'));
      }
    });
  }
}