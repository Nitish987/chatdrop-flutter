abstract class LoginState {}

class LoginInitialState extends LoginState {}
class LoginSuccessState extends LoginState {}
class LoginFailedState extends LoginState {
  final String error;
  LoginFailedState(this.error);
}
class LoginProgressState extends LoginState {}

// GSAC means Google Sign in Account Creation
class GSACState extends LoginState {
  final String gsacToken;
  final String idToken;
  GSACState(this.gsacToken, this.idToken);
}
