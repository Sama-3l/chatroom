import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  bool isme;

  Message({
    required this.message,
    required this.dateTime,
    required this.isme,
  });
}
