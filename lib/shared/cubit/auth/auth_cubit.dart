import 'package:chatdrop/shared/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

// user auth state
class AuthenticationCubit extends Cubit<AuthState> {
  AuthenticationCubit() : super(AuthInitialState()) {
    setAuthenticationState();
  }

  void setAuthenticationState() {
    UserService.instance.then((userService) {
      String? uid = userService.getUserId();
      if (userService.getAuthenticationState() && uid != null) {
          emit(Authenticated(uid));
      } else {
        emit(UnAuthenticated());
      }
    });
  }
}
