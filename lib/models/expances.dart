import 'package:isar/isar.dart';

part 'expances.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;

  late String uid;
  late String name;
  late String email;
  DateTime? timestamp;
}

@collection
class Messages {
  Id id = Isar.autoIncrement;

  late String senderId;
  late String senderEmail;
  late String receiverId;
  late String message;
  DateTime? timestamp;
}
