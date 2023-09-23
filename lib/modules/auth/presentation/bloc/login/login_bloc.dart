import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

// Login State Management
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService = AuthService();

  LoginBloc() : super(LoginInitialState()) {
    progressEvent();
    loginCredSubmitEvent();
    googleSignInCredSubmitEvent();
  }

  void progressEvent() {
    on<ProgressEvent>((event, emit) {
      if (event.name == 'initial') {
        if (state is! LoginInitialState) {
          emit(LoginInitialState());
        }
      } else if (event.name == 'loading') {
        if (state is! LoginProgressState) {
          emit(LoginProgressState());
        }
      }
    });
  }

  void loginCredSubmitEvent() {
    on<LoginCredentialsSubmitEvent>((event, emit) async {
      if (event.email.isEmpty || !EmailValidator.validate(event.email)) {
        emit(LoginFailedState('Please enter valid email.'));
      } else if (event.password.length < 8 || event.password.length > 32) {
        emit(LoginFailedState(
            'Password should contains at least 8 Characters.'));
      } else {
        if (state is! LoginProgressState) {
          emit(LoginProgressState());
        }
        final result = await _authService.login(email: event.email, password: event.password);
        if (result['success']) {
          emit(LoginSuccessState());
        } else {
          emit(LoginFailedState(result['error']));
        }
      }
    });
  }

  void googleSignInCredSubmitEvent() {
    on<GoogleSignInCredentialsSubmitEvent>((event, emit) async {
      emit(LoginProgressState());
      final result = await _authService.googleSignIn(idToken: event.idToken);
      if (result['success']) {
        if (result['type'] == 'GSAC') {
          emit(GSACState(result['token'], event.idToken));
        } else {
          emit(LoginSuccessState());
        }
      } else {
        emit(LoginFailedState(result['error']));
      }
    });
  }
}
