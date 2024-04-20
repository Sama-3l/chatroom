import 'package:chatroom/data/models/message.dart';
import 'package:hive/hive.dart';
part 'session.g.dart';

@HiveType(typeId: 1)
class Session extends HiveObject {
  @HiveField(0)
  List<Message> messages;

  @HiveField(1)
  int sessionId;

  @HiveField(2)
  String chatRoomName;

  Session({
    required this.messages,
    required this.sessionId,
    required this.chatRoomName,
  });
}
