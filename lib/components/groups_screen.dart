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

  double get _total {
    double sum = 0;
    for (var text in task.notes) {
      final match = RegExp(r'\d+').firstMatch(text);
      if (match != null) {
        sum += double.parse(match.group(0)!);
      }
    }
    return sum;
  }

  void addNotes() async {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        task.notes.add(text);
        controller.clear();
      });
      await task.save();
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Для того ,что бы удалить нажмите на текст'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteNotes() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        groupBox.delete(0);
      });
      task.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004D00),
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
            Padding(padding: EdgeInsets.symmetric(horizontal: 40)),
          ],
        ),
        backgroundColor: Color(0xFF004400),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 600,
                  color: Color(0xFF1B5E20),
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
                          fillColor: Color(0xFF2E7D32),
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
                          color: Color(0xFF2E7D32),
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
                              onPressed: () {
                                if (groupBox.isNotEmpty) {
                                  task.notes.removeAt(index);
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 7)),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 70,
                width: 140,
                child: Center(
                  child: Text('${_total}', style: TextStyle(fontSize: 17)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
