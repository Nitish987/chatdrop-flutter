import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_bloc.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/bloc/search/search_bloc.dart';
import 'package:chatdrop/shared/bloc/search/search_event.dart';
import 'package:chatdrop/shared/bloc/search/search_state.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/illustrations/search.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/audio/audio_event.dart';
import '../widgets/audio.dart';
import '../widgets/audio_option_sheet.dart';

class SearchAudioDelegate extends SearchDelegate<AudioModel?>  {
  late String _authUserUid;
  late AudioPlayer _audioPlayer;
  late AudioBloc audioBloc;
  late SearchBloc searchBloc;

  SearchAudioDelegate({required String authUserUid, required AudioPlayer player, required this.audioBloc, required this.searchBloc}) {
    _authUserUid = authUserUid;
    _audioPlayer = player;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(StartAudioSearchingEvent(query));
    return _listResultsWidget();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Search(
      label: 'Search for audio.',
    );
  }

  Widget _listResultsWidget() {
    return BlocProvider.value(
      value: searchBloc,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchSuccessState<AudioModel>) {
            List<AudioModel> audios = state.result;

            if (audios.isEmpty) {
              return const Nothing(label: 'No Audio Found.');
            }

            return ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                AudioModel audio = audios[index];
                return Audio(
                  key: Key(audio.id.toString()),
                  sameUser: _authUserUid == audio.user!.uid,
                  audio: audio,
                  player: _audioPlayer,
                  onTap: () {
                    Navigator.pop(context, audio);
                  },
                  onOption: () {
                    if (_audioPlayer.playing) {
                      _audioPlayer.pause();
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AudioOptionSheet(
                        sameUser: _authUserUid == audio.user!.uid,
                        onDelete: () {
                          audioBloc.add(DeleteAudioEvent(audio.id!));
                        },
                        onReport: () {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushNamed(context, Routes.reportUser, arguments: {
                              'uid': audio.user!.uid!
                            });
                          });
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
          return const ListTileShimmerLoading();
        },
      ),
    );
  }
}