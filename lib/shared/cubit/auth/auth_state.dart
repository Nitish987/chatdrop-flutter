// Authentication States
abstract class AuthState {}

class AuthInitialState extends AuthState {}
class UnAuthenticated extends AuthState {}
class Authenticated extends AuthState {
  final String uid;
  Authenticated(this.uid);
}