import 'package:expend/hive_adapter/hive_adapter.dart';
import 'package:expend/screens/groups_screen.dart';
import 'package:expend/screens/income.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Box<Tasks> groupBox;
  final TextEditingController controller = TextEditingController();
  bool isVisible = false;
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
      controller.clear();
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Задайте название вашей теме',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      createGroup();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Задать'),
                ),
              ],
            ),
            // Text('Задайте название или попробуйте поменять'),
            backgroundColor: Colors.green,
          );
        },
      );
    }
  }

  void openTask(int index) {
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => GroupsScreen(groupIndex: index),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 500),
          ),
        )
        .then((_) => setState(() {}));
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
              
            ],
            backgroundColor: Colors.transparent,
            toolbarHeight: 100,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Расходы',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    IconButton(
                      onPressed: () {Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Income(),
                  ),
                );
              },
                      icon: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 495,
                      width: 400,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 55,
                            ),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (int i = 0; i < groupBox.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      openTask(i);
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(16),
                                          child: Container(
                                            height: 180,
                                            width: 140,
                                            color: Colors.green[800],
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${groupBox.getAt(i)!.value}',
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  '${groupBox.getAt(i)!.total ?? 0.0}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      Text(
                                                        'Вы точно хотите удалить?',
                                                      ),
                                                      Row(
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              if (groupBox
                                                                  .isNotEmpty) {
                                                                groupBox
                                                                    .deleteAt(
                                                                      i,
                                                                    );
                                                                setState(() {});
                                                                Navigator.of(
                                                                  context,
                                                                ).pop();
                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Text('Да'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
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
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: createGroup,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.green[700],
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add, size: 50),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                      ),
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
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(padding: EdgeInsets.symmetric(vertical: 75)),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 85,
                          width: 370,
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  width: 5,
                                  child: IconButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/icons/home.svg',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 70,
                                  width: 10,
                                  child: IconButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor: WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/icons/settings.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
