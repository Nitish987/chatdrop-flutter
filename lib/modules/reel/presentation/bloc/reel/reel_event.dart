abstract class ReelEvent {}

class AddReelEvent extends ReelEvent {
  final String visibility;
  final String hashtags;
  final String text;
  final String videoPath;
  final String thumbnailPath;
  final double aspectRatio;
  final int audioId;

  AddReelEvent({
    required this.visibility,
    required this.hashtags,
    required this.videoPath,
    required this.thumbnailPath,
    required this.aspectRatio,
    this.text = '',
    this.audioId = 0,
  });
}

class ListReelEvent extends ReelEvent {
  final String uid;

  ListReelEvent(this.uid);
}