abstract class ForgetPasswordState {}

class ForgetPasswordInitialState extends ForgetPasswordState {}
class ForgetPasswordEmailSuccessState extends ForgetPasswordState {
  final String message;
  final String proToken;
  final String prrToken;
  ForgetPasswordEmailSuccessState({required this.message, required this.proToken, required this.prrToken});
}
class ForgetPasswordVerificationSuccessState extends ForgetPasswordState {
  final String message;
  final String prnpToken;
  ForgetPasswordVerificationSuccessState({required this.message, required this.prnpToken});
}
class ForgetPasswordSuccessState extends ForgetPasswordState {
  final String message;
  ForgetPasswordSuccessState(this.message);
}
class ForgetPasswordFailedState extends ForgetPasswordState {
  final String error;
  ForgetPasswordFailedState(this.error);
}
class ForgetPasswordProgressState extends ForgetPasswordState {}