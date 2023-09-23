import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final AuthService _authService = AuthService();

  ForgetPasswordBloc() : super(ForgetPasswordInitialState()) {
    forgetPasswordEmailSubmitEvent();
    forgetPasswordVerificationEvent();
    forgetPasswordResentOtpEvent();
    newPasswordSubmitEvent();
  }

  void forgetPasswordEmailSubmitEvent() {
    on<ForgetPasswordEmailSubmitEvent>((event, emit) async {
      if (event.email.isEmpty || !EmailValidator.validate(event.email)) {
        emit(ForgetPasswordFailedState('Please enter valid email.'));
        emit(ForgetPasswordInitialState());
      } else {
        emit(ForgetPasswordProgressState());
        final result = await _authService.forgetPassword(email: event.email);
        if (result['success']) {
          emit(ForgetPasswordEmailSuccessState(
              message: 'Enter the OTP sent to your email ${event.email}',
              proToken: result['proToken'],
              prrToken: result['prrToken']));
        } else {
          emit(ForgetPasswordFailedState(result['error']));
          emit(ForgetPasswordInitialState());
        }
      }
    });
  }

  void forgetPasswordVerificationEvent() {
    on<ForgetPasswordVerificationEvent>((event, emit) async {
      if (event.otp.isEmpty) {
        emit(ForgetPasswordFailedState('Please enter valid otp of 6 digits.'));
        emit(ForgetPasswordEmailSuccessState(
            message: 'Enter the OTP sent to your linked Email.',
            proToken: event.proToken,
            prrToken: event.prrToken));
      } else {
        emit(ForgetPasswordProgressState());
        final result = await _authService.forgetPasswordOtpVerification(
            otp: event.otp, proToken: event.proToken, prrToken: event.prrToken);
        if (result['success']) {
          emit(
            ForgetPasswordVerificationSuccessState(
              message: 'Create Your new password',
              prnpToken: result['prnpToken'],
            ),
          );
        } else {
          emit(ForgetPasswordFailedState(result['error']));
          emit(ForgetPasswordEmailSuccessState(
              message: 'Enter the OTP sent to your linked Email.',
              proToken: event.proToken,
              prrToken: event.prrToken));
        }
      }
    });
  }

  void forgetPasswordResentOtpEvent() {
    on<ForgetPasswordResentOtpEvent>((event, emit) async {
      emit(ForgetPasswordProgressState());
      final result = await _authService.forgetPasswordOtpResent(
          proToken: event.proToken, prrToken: event.prrToken);
      if (result['success']) {
        emit(ForgetPasswordEmailSuccessState(
            message: 'Enter the OTP sent to your linked Email.',
            proToken: result['proToken'],
            prrToken: result['prrToken']));
      } else {
        emit(ForgetPasswordFailedState(result['error']));
        emit(ForgetPasswordEmailSuccessState(
            message: 'Enter the OTP sent to your linked Email.',
            proToken: event.proToken,
            prrToken: event.prrToken));
      }
    });
  }

  void newPasswordSubmitEvent() {
    on<NewPasswordSubmitEvent>((event, emit) async {
      if (event.password.length < 8 || event.password.length > 32) {
        emit(ForgetPasswordFailedState(
            'Password should contains at least 8 Characters.'));
        emit(
          ForgetPasswordVerificationSuccessState(
            message: 'Create Your new password',
            prnpToken: event.prnpToken,
          ),
        );
      } else if (event.password != event.rePassword) {
        emit(ForgetPasswordFailedState("Password doesn't match"));
        emit(
          ForgetPasswordVerificationSuccessState(
            message: 'Create Your new password',
            prnpToken: event.prnpToken,
          ),
        );
      } else {
        emit(ForgetPasswordProgressState());
        final result = await _authService.forgetPasswordSetNewPassword(
            password: event.password, prnpToken: event.prnpToken);
        if (result['success']) {
          emit(ForgetPasswordSuccessState('Password Changed Successfully.'));
        } else {
          emit(ForgetPasswordFailedState(result['error']));
          emit(
            ForgetPasswordVerificationSuccessState(
              message: 'Create Your new password',
              prnpToken: event.prnpToken,
            ),
          );
        }
      }
    });
  }
}
