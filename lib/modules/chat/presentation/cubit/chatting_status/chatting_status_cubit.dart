import 'package:chatdrop/modules/chat/presentation/cubit/chatting_status/chatting_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChattingStatusCubit extends Cubit<ChattingStatusState> {
  ChattingStatusCubit() : super(ChattingStatusState.offline);

  void updateStatus(String status) {
    if(status == 'offline') {
      emit(ChattingStatusState.offline);
    } else if (status == 'online') {
      emit(ChattingStatusState.online);
    } else if (status == 'typing') {
      emit(ChattingStatusState.typing);
    }
  }
}