import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GroupsScreen extends StatefulWidget {
  final int groupIndex;
  const GroupsScreen({super.key, required this.groupIndex});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Box<Tasks> groupBox;
  late Tasks task;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupBox = Hive.box<Tasks>('tasks');
    task = groupBox.getAt(widget.groupIndex)!;
  }

  int get _total {
    int sum = 0;
    for (var text in task.notes) {
      final match = RegExp(r'\d+').firstMatch(text);
      if (match != null) {
        sum += int.parse(match.group(0)!);
      }
    }
    return sum;
  }

  void addNotes() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        task.notes.add(text);
        controller.clear();
      });
    }
  }

  void deleteNotes() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        task.notes.removeAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003300),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text('${task.value}', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color(0xFF004400),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            color: Color(0xFF004400),
            // Color.fromRGBO(1, 89, 1, 1.0),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.green[700],
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green[700],
                    child: IconButton(
                      onPressed: addNotes,
                      style: ButtonStyle(),
                      icon: Icon(Icons.add_sharp),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: task.notes.length,
                    itemBuilder: (_, index) => ListTile(
                      title: TextButton(
                        child: Text(
                          '${task.notes[index]}',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: deleteNotes,
                      ),
                    ),
                  ),
                ),
                Text('Сумма: ${_total}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
