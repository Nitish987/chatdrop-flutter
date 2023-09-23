abstract class PasswordChangeEvent {}

class PasswordChangeRequestEvent extends PasswordChangeEvent{
  String currentPass, newPass, renewPass;
  PasswordChangeRequestEvent(this.currentPass, this.newPass, this.renewPass);
}