import 'package:flutter/material.dart'
    show
        BorderSide,
        BuildContext,
        Color,
        Colors,
        EdgeInsets,
        InputDecoration,
        Key,
        OutlineInputBorder,
        Padding,
        SizedBox,
        StatelessWidget,
        TextField,
        TextInputType,
        TextStyle,
        VoidCallback,
        Widget;
import 'package:get/get_state_manager/get_state_manager.dart' show GetBuilder;
import 'package:quiz_app/controllers/question_controller.dart'
    show QuestionController;

import '../../../constants.dart';

class OpenAnswer extends StatelessWidget {
  const OpenAnswer({
    Key? key,
    required this.text,
    required this.index,
    required this.press,
  }) : super(key: key);
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          Color getTheRightColor() {
            if (qnController.isAnswered) {
              if (index == qnController.correctAns) {
                return kGreenColor;
              } else if (index == qnController.selectedAns &&
                  qnController.selectedAns != qnController.correctAns) {
                return kRedColor;
              }
            }
            return kGrayColor;
          }

          // ignore: todo
          // TODO: BINNENKORT VERWIJDEREN!
          // zodra open answer volledig werkt

          var maxLines = 5;
          return Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: maxLines * 50.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter a message",
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: getTheRightColor(), width: 0.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: getTheRightColor(), width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: getTheRightColor(), width: 0.0),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: maxLines,
              ),
            ),
          );
        });
  }
}
