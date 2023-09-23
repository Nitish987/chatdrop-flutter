import 'package:chatdrop/shared/bloc/search/search_event.dart';
import 'package:chatdrop/shared/bloc/search/search_state.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/search_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService _searchService = SearchService();

  SearchBloc() : super(SearchInitialState()) {
    startProfileSearchingEvent();
    startAudioSearchingEvent();
  }

  void startProfileSearchingEvent() {
    on<StartProfileSearchingEvent>((event, emit) async {
      emit(SearchLoadingState());
      final result = await _searchService.searchProfiles(event.query);
      if (result == null) {
        emit(SearchFailedState('Unable to Search.'));
      } else {
        emit(SearchSuccessState<UserModel>(result));
      }
    });
  }

  void startAudioSearchingEvent() {
    on<StartAudioSearchingEvent>((event, emit) async {
      emit(SearchLoadingState());
      final result = await _searchService.searchAudios(event.query);
      if (result == null) {
        emit(SearchFailedState('Unable to Search.'));
      } else {
        emit(SearchSuccessState<AudioModel>(result));
      }
    });
  }
}