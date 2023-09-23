import 'dart:io';

import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_bloc.dart';
import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_event.dart';
import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_state.dart';
import 'package:chatdrop/modules/camera/presentation/delegate/search_audio_delegate.dart';
import 'package:chatdrop/modules/camera/presentation/widgets/audio_option_sheet.dart';
import 'package:chatdrop/settings/routes/routes.dart';
import 'package:chatdrop/shared/bloc/search/search_bloc.dart';
import 'package:chatdrop/shared/cubit/auth/auth_cubit.dart';
import 'package:chatdrop/shared/cubit/auth/auth_state.dart';
import 'package:chatdrop/shared/illustrations/nothing.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/tools/snackbar_message.dart';
import 'package:chatdrop/shared/widgets/appbar_title.dart';
import 'package:chatdrop/shared/widgets/list_tile_shimmer_loading.dart';
import 'package:chatdrop/shared/widgets/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../widgets/audio.dart';

class AudioSelectPage extends StatefulWidget {
  const AudioSelectPage({super.key});

  @override
  State<AudioSelectPage> createState() => _AudioSelectPageState();
}

class _AudioSelectPageState extends State<AudioSelectPage> {
  late final AudioBloc audioBloc = BlocProvider.of<AudioBloc>(context);
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<File?> _pickAudio() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      PlatformFile platformFile = result.files[0];
      return File(platformFile.path!);
    }
    return null;
  }

  void _onAddAudioButtonClicked() async {
    File? file = await _pickAudio();
    if (file == null) {
      return;
    }
    final player = AudioPlayer();
    final duration = await player.setFilePath(file.path);
    if (duration == null) {
      return;
    }

    if (mounted) {
      if (duration.inSeconds > 60) {
        ErrorSnackBar.show(context, 'Audio must be of 60 second or less.');
        return;
      }
      audioBloc.add(
        AddAudioEvent(
          name: file.path.split('/').last.split('.').first,
          audioPath: file.path,
          duration: duration.inSeconds,
        ),
      );
    }
  }

  @override
  void initState() {
    audioBloc.add(ListAudioEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const AppBarTitle(title: 'Audio Track'),
              actions: [
                IconButton(
                  onPressed: () async {
                    AudioModel? user = await showSearch<AudioModel?>(
                      context: context,
                      delegate: SearchAudioDelegate(
                        authUserUid: authState.uid,
                        player: _audioPlayer,
                        audioBloc: audioBloc,
                        searchBloc: BlocProvider.of<SearchBloc>(context),
                      ),
                    );
                    if (mounted) {
                      Navigator.pop(context, user);
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                if (state is ListAudioState) {
                  List<AudioModel> audios = state.audios;

                  if (audios.isEmpty) {
                    return const Nothing(label: 'No Audio Found.');
                  }

                  return ListView.builder(
                    itemCount: audios.length,
                    itemBuilder: (context, index) {
                      AudioModel audio = audios[index];
                      return Audio(
                        key: Key(audio.id.toString()),
                        sameUser: authState.uid == audio.user!.uid,
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
                              sameUser: authState.uid == audio.user!.uid,
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
            floatingActionButton: BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  Color backgroundColor = Colors.blue;
                  Widget child = const Icon(Icons.add);

                  if (state is LoadingAudioState) {
                    backgroundColor = Colors.white;
                    child = const Loading();
                  }

                  return FloatingActionButton(
                    onPressed: state is LoadingAudioState ? () {
                      ProcessSnackBar.show(context, 'Listing Audio...');
                    } : _onAddAudioButtonClicked,
                    backgroundColor: backgroundColor,
                    child: child,
                  );
                }
            ),
          );
        }
        return const Scaffold();
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
