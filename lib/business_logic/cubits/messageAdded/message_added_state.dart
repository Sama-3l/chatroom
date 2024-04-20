part of 'message_added_cubit.dart';

@immutable
sealed class MessageAddedState {}

final class MessageAddedInitial extends MessageAddedState {}

final class AddedMessageState extends MessageAddedState {}
