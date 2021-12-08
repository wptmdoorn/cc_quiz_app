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
  // Custom initialisatie
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    print('Initializing app');

    // load() functie is voor nu overbodig
    // we laden nu data in nadat je de opties selecteert
    // zodra vragen online staan (als binair formaat), dan kunnen we hier
    // mogelijk al checken voor versie number van online file; evt overwegen
    // of we altijd lokaal kopie moeten opslaan zodat mensen het ook offline
    // kunnen spelen
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Klinische Chemie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // willen we dark?
      home: WelcomeScreen(),
    );
  }
}
