import 'package:hive/hive.dart';
part 'hive_adapter.g.dart';

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  String? value;
  List<String> notes;
  int? total;

  Tasks({this.value, required this.notes, this.total});
}

@HiveType(typeId: 1)
class Lists extends HiveObject {
  @HiveField(0)
  List<String> list;
  Lists({required this.list});
}

@HiveType(typeId: 2)
class SaveDB extends HiveObject {
  @HiveField(0)
  Tasks tasks;
  SaveDB({required this.tasks});
}
