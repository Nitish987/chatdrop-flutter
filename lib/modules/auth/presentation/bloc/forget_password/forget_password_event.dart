abstract class ForgetPasswordEvent {}

class ForgetPasswordEmailSubmitEvent extends ForgetPasswordEvent {
  final String email;
  ForgetPasswordEmailSubmitEvent(this.email);
}

class ForgetPasswordVerificationEvent extends ForgetPasswordEvent {
  final String otp;
  final String proToken;
  final String prrToken;
  ForgetPasswordVerificationEvent({required this.otp, required this.proToken, required this.prrToken});
}

class ForgetPasswordResentOtpEvent extends ForgetPasswordEvent {
  final String proToken;
  final String prrToken;
  ForgetPasswordResentOtpEvent({required this.proToken, required this.prrToken});
}

class NewPasswordSubmitEvent extends ForgetPasswordEvent {
  final String password;
  final String rePassword;
  final String prnpToken;
  NewPasswordSubmitEvent({required this.password, required this.rePassword, required this.prnpToken});
}