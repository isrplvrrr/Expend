import 'package:expend/components/groups_screen.dart';
import 'package:expend/database/database.dart';
import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box<Tasks> groupBox;
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    groupBox = Hive.box<Tasks>('tasks');
    super.initState();
  }

  void createGroup() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      final task = Tasks(value: text, notes: []);
      groupBox.add(task);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Задайте название или попробуйте поменять'),
            backgroundColor: Colors.green,
          );
        },
      );
    }
  }

  void openTask(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GroupsScreen(groupIndex: index)),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.green],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.green],
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            toolbarHeight: 100,
            title: Text(
              'Мои \n   задачи',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Задайте название вашей теме',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    controller: controller,
                    style: TextStyle(color: Colors.white),
                  ),
                  for (int i = 0; i < groupBox.length; i++)
                    GestureDetector(
                      onTap: () => openTask(i),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: Container(
                              height: 200,
                              width: 150,
                              color: Colors.green[800],
                              alignment: Alignment.center,
                              child: Text(
                                '${groupBox.getAt(i)!.value}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              box.deleteAt(i);
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),

                  GestureDetector(
                    onTap: createGroup,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.green[700],
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.add, size: 50)],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Text(
                          'Создать группу',
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
