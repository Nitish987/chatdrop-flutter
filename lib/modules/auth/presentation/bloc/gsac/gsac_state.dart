abstract class GSACState {}

class GSACInitialState extends GSACState {}

class GSACLoadingState extends GSACState {}

class GSACSuccessState extends GSACState {}

class GSACFailedState extends GSACState {
  final String error;
  GSACFailedState(this.error);
}