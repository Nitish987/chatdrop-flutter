import 'package:chatdrop/shared/services/auth_service.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_event.dart';
import 'package:chatdrop/modules/auth/presentation/bloc/change_password/change_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordChangeBloc extends Bloc<PasswordChangeEvent, PasswordChangeState> {
  final AuthService _authService = AuthService();

  PasswordChangeBloc() : super(InitialPasswordChangeState()) {
    changePasswordRequestEvent();
  }

  void changePasswordRequestEvent() {
    on<PasswordChangeRequestEvent>((event, emit) async {
      if (event.currentPass.length < 8 || event.currentPass.length > 32 || event.newPass.length < 8 || event.newPass.length > 32) {
        emit(FailedPasswordChangeState('Password should contains at least 8 Characters.'));
      } else if(event.newPass != event.renewPass) {
        emit(FailedPasswordChangeState('Password does not matched.'));
      } else {
        emit(LoadingPasswordChangeState());
        final result = await _authService.changePassword(currentPass: event.currentPass, newPass: event.newPass);
        if (result['success']) {
          emit(SuccessPasswordChangeState(result['message']));
        } else {
          emit(FailedPasswordChangeState(result['error']));
        }
      }
    });
  }
}