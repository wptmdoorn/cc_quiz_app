import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/models/Questions.dart';

import '../../../constants.dart';
import 'option.dart';

// variant van de multiple-choice vraag
// in essentie het zelfde, alleen op L24 hebben we '2 opties' hardcoded
// dit komt omdat we in de database file altijd 4 antwoorden hebben (wv laatste
// 2 leeg zijn bij true-false), maar daardoor we dit nu dus hardcoden

class QuestionCardTrueFalse extends StatelessWidget {
  const QuestionCardTrueFalse({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.question!,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kBlackColor),
          ),
          SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            2, // only true and false
            (index) => Option(
              index: index,
              text: question.options![index]!,
              press: () => _controller.checkAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
