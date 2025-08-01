import 'package:expend/database/database.dart';
import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expend/hive_names/hive_names.dart';
import 'package:expend/main_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TasksAdapter());
  await Hive.openBox<Tasks>(HiveBoxes.tasks);
  Hive.registerAdapter(ListsAdapter());
  await Hive.openBox<Lists>(HiveBoxes.lists);
  print('${box.isOpen}');
  print(lists.isEmpty);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: MainScreen());
  }
}
