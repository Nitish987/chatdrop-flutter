import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

// Signup State Management
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService = AuthService();

  SignupBloc() : super(SignupInitialState()) {
    signupDetailSubmitEvent();
    signupVerificationEvent();
    signupResentOtpEvent();
  }

  void signupDetailSubmitEvent() {
    on<SignupDetailSubmitEvent>((event, emit) async {
      if (event.firstName.isEmpty || event.firstName.length < 3) {
        emit(SignupFailedState(
            'First name must contains at least 3 characters.'));
        emit(SignupInitialState());
      } else if (event.lastName.isEmpty || event.lastName.length < 2) {
        emit(SignupFailedState(
            'Last name must contains at least 2 characters.'));
        emit(SignupInitialState());
      } else if (event.gender.isEmpty) {
        emit(SignupFailedState('Gender Must be specified.'));
        emit(SignupInitialState());
      } else if (event.dateOfBirth.isEmpty) {
        emit(SignupFailedState('Invalid Date of Birth.'));
        emit(SignupInitialState());
      } else if (event.email.isEmpty || !EmailValidator.validate(event.email)) {
        emit(SignupFailedState('Please enter valid email.'));
        emit(SignupInitialState());
      } else if (event.password.isEmpty ||
          event.password.length < 8 ||
          event.password.length > 32) {
        emit(SignupFailedState(
            'Password should contains at least 8 Characters.'));
        emit(SignupInitialState());
      } else if (event.password != event.rePassword) {
        emit(SignupFailedState("Password doesn't match."));
        emit(SignupInitialState());
      } else {
        emit(SignupProgressState());
        final result = await _authService.signup(
          firstName: event.firstName,
          lastName: event.lastName,
          gender: event.gender,
          dateOfBirth: event.dateOfBirth,
          email: event.email,
          password: event.password,
          rePassword: event.rePassword,
        );
        if (result['success']) {
          emit(SignupDetailSuccessState(
            message: 'Enter the otp send to your email ${event.email}',
            soToken: result['soToken'],
            srToken: result['srToken'],
          ));
        } else {
          emit(SignupFailedState(result['error']));
          emit(SignupInitialState());
        }
      }
    });
  }

  void signupVerificationEvent() {
    on<SignupVerificationEvent>((event, emit) async {
      if (event.otp.isEmpty) {
        emit(SignupFailedState('Please enter valid otp of 6 digits.'));
        emit(
          SignupDetailSuccessState(
            message: 'Enter the OTP sent to your linked Email.',
            soToken: event.soToken,
            srToken: event.srToken,
          ),
        );
      } else {
        emit(SignupProgressState());
        final result = await _authService.signupVerification(
            otp: event.otp, soToken: event.soToken, srToken: event.srToken);
        if (result['success']) {
          emit(SignupVerificationSuccessState('Account Created Successfully.'));
        } else {
          emit(SignupFailedState(result['error']));
          emit(
            SignupDetailSuccessState(
              message: 'Enter the OTP sent to your linked Email.',
              soToken: event.soToken,
              srToken: event.srToken,
            ),
          );
        }
      }
    });
  }

  void signupResentOtpEvent() {
    on<SignupResentOtpEvent>((event, emit) async {
      emit(SignupProgressState());
      final result = await _authService.signupOtpResent(
          soToken: event.soToken, srToken: event.srToken);
      if (result['success']) {
        emit(SignupDetailSuccessState(
          message: 'Enter the otp send to your Email.',
          soToken: result['soToken'],
          srToken: result['srToken'],
        ));
      } else {
        emit(SignupFailedState(result['error']));
        emit(SignupDetailSuccessState(
            message: 'Enter the OTP sent to your linked Email.',
            soToken: event.soToken,
            srToken: event.srToken));
      }
    });
  }
}
