import 'package:hive/hive.dart';

part 'note.g.dart'; // File này sẽ được tự động tạo ra

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
  });
}