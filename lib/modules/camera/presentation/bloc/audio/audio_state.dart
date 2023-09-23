import 'package:chatdrop/shared/models/audio_model/audio_model.dart';

abstract class AudioState {}

class LoadingAudioState extends AudioState {}

class ListAudioState extends AudioState {
  List<AudioModel> audios;
  ListAudioState(this.audios);
}