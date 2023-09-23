abstract class SearchState {}

class SearchInitialState extends SearchState {}
class SearchSuccessState<T> extends SearchState {
  final List<T> result;
  SearchSuccessState(this.result);
}
class SearchLoadingState extends SearchState {}
class SearchFailedState extends SearchState {
  final String error;
  SearchFailedState(this.error);
}