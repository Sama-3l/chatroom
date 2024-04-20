import 'package:chatroom/data/models/session.dart';
import 'package:hive/hive.dart';

class Sessions extends HiveObject {
  List<Session> sessions;

  Sessions({required this.sessions});
}
