import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_chat_session_state.dart';

class ChangeChatSessionCubit extends Cubit<ChangeChatSessionState> {
  ChangeChatSessionCubit() : super(ChangeChatSessionInitial(sessionsId: 1));

  onChangedSession(int session) => emit(ChatSessionChanged(sessionsId: session));
}
