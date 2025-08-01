import 'package:hive/hive.dart';
part 'hive_adapter.g.dart';

@HiveType(typeId: 0)
class Tasks extends HiveObject {
  @HiveField(0)
  String? value;

  @HiveField(1)
  List<String> notes;

  @HiveField(2)
  int? total;

  Tasks({this.value, this.total, List<String>? notes})
    : this.notes = notes ?? [];
}

@HiveType(typeId: 1)
class Lists extends HiveObject {
  @HiveField(0)
  List<dynamic> list;
  Lists({required this.list});
}

@HiveType(typeId: 2)
class SaveDB extends HiveObject {
  @HiveField(0)
  Tasks tasks;
  SaveDB({required this.tasks});
}
