part of 'edit_session_name_cubit.dart';

@immutable
sealed class EditSessionNameState {
  final int currentIndex;
  const EditSessionNameState({required this.currentIndex});
}

final class EditSessionNameInitial extends EditSessionNameState {
  const EditSessionNameInitial({required super.currentIndex});
}

final class SessionNameChange extends EditSessionNameState {
  const SessionNameChange({required super.currentIndex});
}
