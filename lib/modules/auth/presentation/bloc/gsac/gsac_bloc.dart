import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'gsac_event.dart';
import 'gsac_state.dart';

class GSACBloc extends Bloc<GSACEvent, GSACState> {
  final AuthService _authService = AuthService();

  GSACBloc() : super(GSACInitialState()) {
    accountDetailsSubmitEvent();
  }

  void accountDetailsSubmitEvent() {
    on<AccountDetailsSubmitEvent>((event, emit) async {
      if (event.gender.isEmpty) {
        emit(GSACFailedState('Gender Must be specified.'));
        emit(GSACInitialState());
      } else if (event.dateOfBirth.isEmpty) {
        emit(GSACFailedState('Invalid Date of Birth.'));
        emit(GSACInitialState());
      } else if (event.password.isEmpty ||
          event.password.length < 8 ||
          event.password.length > 32) {
        emit(GSACFailedState(
            'Password should contains at least 8 Characters.'));
        emit(GSACInitialState());
      } else if (event.password != event.rePassword) {
        emit(GSACFailedState("Password doesn't match."));
        emit(GSACInitialState());
      } else {
        emit(GSACLoadingState());
        final result = await _authService.googleSignInAccountCreation(
          idToken: event.idToken,
          gsacToken: event.gsacToken,
          gender: event.gender,
          dateOfBirth: event.dateOfBirth,
          password: event.password,
        );
        if (result['success']) {
          emit(GSACSuccessState());
        } else {
          emit(GSACFailedState(result['error']));
          emit(GSACInitialState());
        }
      }
    });
  }
}