import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String? displayName;

  @HiveField(4)
  DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.displayName,
    required this.createdAt,
  });
}
