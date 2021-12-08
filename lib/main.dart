import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quiz_app/screens/welcome/welcome_screen.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:get/get.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State {
  // This widget is the root of your application.
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    print('Initializing app');
    print('Loading data');
    QuestionController _controller = Get.put(await QuestionController.create());

    print('Found questions, number: ');
    print(_controller.questions.length);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Klinische Chemie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
    );
  }
}
