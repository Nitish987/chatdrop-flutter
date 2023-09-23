import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_names_event.dart';
import 'change_names_state.dart';

class ChangeNamesBloc extends Bloc<ChangeNamesEvent, ChangeNamesState> {
  final AuthService _authService = AuthService();

  ChangeNamesBloc() : super(InitialChangeState()) {
    updateNamesEvent();
  }

  void updateNamesEvent() {
    on<UpdateNamesEvent>((event, emit) async {
      if (event.firstName.isEmpty || event.firstName.length < 3) {
        emit(FailedChangeNamesState('First name must contains at least 3 characters.'));
      } else if (event.lastName.isEmpty || event.lastName.length < 2) {
        emit(FailedChangeNamesState('Last name must contains at least 2 characters.'));
      } else  if (event.username.contains('@') || event.username.contains(':')) {
        emit(FailedChangeNamesState('Username must not contains ":" or "@".'));
      } else if (event.password.isEmpty || event.password.length < 8 || event.password.length > 32) {
        emit(FailedChangeNamesState('Password should contains at least 8 Characters.'));
      } else {
        emit(LoadingChangeState());
        final result = await _authService.changeUserNames(
          firstName: event.firstName, lastName: event.lastName, username: event.username, password: event.password,
        );
        if (result['success']) {
          emit(SuccessChangeNamesState());
        } else {
          emit(FailedChangeNamesState(result['error']));
        }
      }
    });
  }
}