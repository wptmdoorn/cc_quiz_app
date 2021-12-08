import 'package:flutter/material.dart';
import 'components/body.dart' show Body;

class QuizStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Opening quiz start page');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Body(),
    );
  }
}
