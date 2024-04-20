part of 'change_chat_session_cubit.dart';

@immutable
sealed class ChangeChatSessionState {
  final int sessionsId;

  ChangeChatSessionState({required this.sessionsId});
}

final class ChangeChatSessionInitial extends ChangeChatSessionState {
  ChangeChatSessionInitial({required super.sessionsId});
}

final class ChatSessionChanged extends ChangeChatSessionState {
  ChatSessionChanged({required super.sessionsId});
}
