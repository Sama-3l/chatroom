import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_session_name_state.dart';

class EditSessionNameCubit extends Cubit<EditSessionNameState> {
  EditSessionNameCubit() : super(EditSessionNameInitial(currentIndex: 0));

  onEditOption(int currentIndex) => emit(SessionNameChange(currentIndex: currentIndex));
}
