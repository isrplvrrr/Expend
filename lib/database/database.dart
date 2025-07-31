import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:expend/hive_names/hive_names.dart';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box<Tasks>(HiveBoxes.tasks);
var list = Hive.box<Lists>(HiveBoxes.lists);
