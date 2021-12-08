import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:quiz_app/screens/quiz/components/question_card_mc%20truefalse.dart';
import 'package:quiz_app/screens/quiz/components/question_card_mc.dart';

import 'progress_bar.dart';
import 'question_card_open.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  // dynamische functie om type van vraagkaart te bepalen
  // is nu support voor open vraag, multiple-choice en true/false
  dynamic getQuestionCard(Question q) {
    if (q.type == "OPEN") {
      return QuestionCardOpen(question: q);
    } else if (q.type == "MC") {
      return QuestionCardMC(question: q);
    } else {
      return QuestionCardTrueFalse(question: q);
    }
  }

  // hoofd functie welke de quiz vrag bouwt
  @override
  Widget build(BuildContext context) {
    // So that we have acccess our controller
    QuestionController _questionController = Get.put(QuestionController());
    print('Building body');
    return Stack(
      children: [
        // background image
        new Container(
            decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        )),

        // content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text:
                          "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kSecondaryColor),
                      children: [
                        TextSpan(
                          text: "/${_questionController.questions.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questionController.questions.length,
                  itemBuilder: (context, index) =>
                      getQuestionCard(_questionController.questions[index]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
