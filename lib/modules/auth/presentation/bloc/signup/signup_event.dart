abstract class SignupEvent {}

class SignupDetailSubmitEvent extends SignupEvent {
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String email;
  final String password;
  final String rePassword;
  SignupDetailSubmitEvent(
      {required this.firstName,
      required this.lastName,
      required this.gender,
      required this.dateOfBirth,
      required this.email,
      required this.password,
      required this.rePassword});
}

class SignupVerificationEvent extends SignupEvent {
  final String otp;
  final String soToken;
  final String srToken;
  SignupVerificationEvent({required this.otp, required this.soToken, required this.srToken});
}

class SignupResentOtpEvent extends SignupEvent {
  final String soToken;
  final String srToken;
  SignupResentOtpEvent({required this.soToken, required this.srToken});
}