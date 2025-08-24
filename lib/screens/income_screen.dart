import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IncomeScreen extends StatefulWidget {
  final int incomeIndex;
  const IncomeScreen({super.key, required this.incomeIndex});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  late Box<Incom> groupBox;
  late Incom incom;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupBox = Hive.box<Incom>('incom');
    incom = groupBox.getAt(widget.incomeIndex)!;
    setState(() {});
  }

  void addNotes() async {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        incom.adds.add(text);
        final match = RegExp(r'\d+').firstMatch(text);
        if (match != null) {
          final num = double.parse(match.group(0)!);
          incom.tatal = (incom.tatal ?? 0.0) + num;
        }
        controller.clear();
      });
      await incom.save();
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Для того ,что бы удалить нажмите на текст'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Напишите расходы'),
            backgroundColor: Colors.green,
          );
        },
      );
    }
  }

  void deleteNotesAt(int index) async {
    final text = incom.adds[index];
    final match = RegExp(r'\d+').firstMatch(text);
    if (match != null) {
      final num = double.parse(match.group(0)!);
      incom.tatal = (incom.tatal ?? 0.0) - num;
    }
    setState(() {
      incom.adds.removeAt(index);
    });
    await incom.save();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004400),
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
            Text('${incom.name}', style: TextStyle(color: Colors.white)),
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
                          itemCount: incom.adds.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              title: TextButton(
                                child: Text(
                                  '${incom.adds[index]}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text('Вы точно хотите удалить?'),
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {});
                                                    if (groupBox.isNotEmpty) {
                                                      incom.adds.removeAt(
                                                        index,
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }
                                                  },
                                                  child: Text('Да'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Нет'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.green,
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                              ),
                            );
                          },
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
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    child: Text(
                      '${incom.tatal ?? 0.0}',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
