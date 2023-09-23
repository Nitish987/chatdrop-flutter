abstract class GSACEvent {}

class AccountDetailsSubmitEvent extends GSACEvent {
  final String idToken;
  final String gsacToken;
  final String gender;
  final String dateOfBirth;
  final String password;
  final String rePassword;

  AccountDetailsSubmitEvent({
    required this.idToken,
    required this.gsacToken,
    required this.gender,
    required this.dateOfBirth,
    required this.password,
    required this.rePassword,
  });
}
