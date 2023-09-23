abstract class AudioEvent {}

class AddAudioEvent extends AudioEvent {
  String name;
  String audioPath;
  int duration;
  AddAudioEvent({required this.name, required this.audioPath, required this.duration});
}

class ListAudioEvent extends AudioEvent {}

class DeleteAudioEvent extends AudioEvent {
  int audioId;
  DeleteAudioEvent(this.audioId);
}