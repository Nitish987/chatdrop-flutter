abstract class SignupState {}

class SignupInitialState extends SignupState {}
class SignupDetailSuccessState extends SignupState {
  final String message;
  final String soToken;
  final String srToken;
  SignupDetailSuccessState({required this.message, required this.soToken, required this.srToken});
}
class SignupVerificationSuccessState extends SignupState {
  final String message;
  SignupVerificationSuccessState(this.message);
}
class SignupFailedState extends SignupState {
  final String error;
  SignupFailedState(this.error);
}
class SignupProgressState extends SignupState {}