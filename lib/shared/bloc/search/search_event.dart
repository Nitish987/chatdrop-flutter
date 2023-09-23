abstract class SearchEvent {}

class StartProfileSearchingEvent extends SearchEvent {
  final String query;
  StartProfileSearchingEvent(this.query);
}

class StartAudioSearchingEvent extends SearchEvent {
  final String query;
  StartAudioSearchingEvent(this.query);
}