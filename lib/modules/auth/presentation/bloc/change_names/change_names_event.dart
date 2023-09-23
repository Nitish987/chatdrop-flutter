abstract class ChangeNamesEvent {}

class UpdateNamesEvent extends ChangeNamesEvent {
  String firstName, lastName, username, password;
  UpdateNamesEvent({required this.firstName, required this.lastName, required this.username, required this.password});
}