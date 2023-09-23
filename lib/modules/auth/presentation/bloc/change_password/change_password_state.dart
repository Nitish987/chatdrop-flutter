abstract class PasswordChangeState {}

class InitialPasswordChangeState extends PasswordChangeState {}

class FailedPasswordChangeState extends PasswordChangeState {
  String error;
  FailedPasswordChangeState(this.error);
}

class LoadingPasswordChangeState extends PasswordChangeState {}

class SuccessPasswordChangeState extends PasswordChangeState {
  String message;
  SuccessPasswordChangeState(this.message);
}