import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_event.dart';
import 'package:chatdrop/modules/camera/presentation/bloc/audio/audio_state.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/services/reel_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final ReelService _reelService = ReelService();
  final List<AudioModel> _audios = [];

  AudioBloc() : super(LoadingAudioState()) {
    addAudioEvent();
    listAudioEvent();
    deleteAudioEvent();
  }

  void addAudioEvent() {
    on<AddAudioEvent>((event, emit) async {
      emit(LoadingAudioState());
      AudioModel? audio = await _reelService.addAudio(event.name, event.audioPath, event.duration);
      if (audio != null) {
        _audios.insert(0, audio);
      }
      emit(ListAudioState(_audios));
    });
  }

  void listAudioEvent() {
    on<ListAudioEvent>((event, emit) async {
      List<AudioModel> audios = await _reelService.listAudio();
      _audios.addAll(audios);
      emit(ListAudioState(_audios));
    });
  }

  void deleteAudioEvent() {
    on<DeleteAudioEvent>((event, emit) async {
      await _reelService.deleteAudio(event.audioId);
      _audios.removeWhere((audio) => audio.id == event.audioId);
      emit(ListAudioState(_audios));
    });
  }
}