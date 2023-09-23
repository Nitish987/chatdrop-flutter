abstract class LoginEvent {}

class ProgressEvent extends LoginEvent {
  final String name;
  ProgressEvent(this.name);
}

class LoginCredentialsSubmitEvent extends LoginEvent {
  final String email;
  final String password;
  LoginCredentialsSubmitEvent(this.email, this.password);
}

class GoogleSignInCredentialsSubmitEvent extends LoginEvent {
  final String idToken;
  GoogleSignInCredentialsSubmitEvent(this.idToken);
}