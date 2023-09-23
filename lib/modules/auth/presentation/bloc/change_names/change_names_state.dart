abstract class ChangeNamesState {}

class InitialChangeState extends ChangeNamesState {}
class LoadingChangeState extends ChangeNamesState {}
class SuccessChangeNamesState extends ChangeNamesState {}
class FailedChangeNamesState extends ChangeNamesState {
  String error;
  FailedChangeNamesState(this.error);
}