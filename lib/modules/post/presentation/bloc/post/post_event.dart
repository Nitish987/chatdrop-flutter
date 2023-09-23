abstract class PostEvent {}

class AddTextPostEvent extends PostEvent {
  final String visibility;
  final String hashtags;
  final String text;

  AddTextPostEvent({required this.visibility, required this.hashtags, required this.text});
}

class AddPhotoPostEvent extends PostEvent {
  final String visibility;
  final String hashtags;
  final List<String> photosPath;
  final List<double> aspectRatios;

  AddPhotoPostEvent({required this.visibility, required this.hashtags, required this.photosPath, required this.aspectRatios});
}

class AddVideoPostEvent extends PostEvent {
  final String visibility;
  final String hashtags;
  final String videoPath;
  final double aspectRatio;
  final String thumbnailPath;

  AddVideoPostEvent({required this.visibility, required this.hashtags, required this.videoPath, required this.aspectRatio, required this.thumbnailPath});
}

class AddTextPhotoPostEvent extends PostEvent {
  final String visibility;
  final String hashtags;
  final String text;
  final List<String> photosPath;
  final List<double> aspectRatios;

  AddTextPhotoPostEvent({required this.visibility, required this.hashtags, required this.text, required this.photosPath, required this.aspectRatios});
}

class AddTextVideoPostEvent extends PostEvent {
  final String visibility;
  final String hashtags;
  final String text;
  final String videoPath;
  final double aspectRatio;
  final String thumbnailPath;

  AddTextVideoPostEvent({required this.visibility, required this.hashtags, required this.text, required this.videoPath, required this.aspectRatio, required this.thumbnailPath});
}

class ListPostEvent extends PostEvent {
  final String uid;

  ListPostEvent(this.uid);
}