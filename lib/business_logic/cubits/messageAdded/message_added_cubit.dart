import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'message_added_state.dart';

class MessageAddedCubit extends Cubit<MessageAddedState> {
  MessageAddedCubit() : super(MessageAddedInitial());

  addMessage() => emit(AddedMessageState());
}
