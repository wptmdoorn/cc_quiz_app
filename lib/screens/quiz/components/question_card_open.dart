import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:quiz_app/screens/quiz/components/openanswer.dart';

import '../../../constants.dart';

// open vragen moeten nog 100% geimplementeerd worden
// voor nu zijn ze wel zichtbaar, alleen werken ze nog niet
// antwoord goed vs fout moet obv popup (DialogWidget)
// verder moet het cosmetisch nog een stuk beter

class QuestionCardOpen extends StatelessWidget {
  const QuestionCardOpen({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  Widget bottomGridTiles(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GridView.count(
            shrinkWrap: true, // Important
            crossAxisCount: 4,
            children: List<Widget>.generate(8, (index) {
              return GridTile(
                  child: Card(
                      color: Colors.blue.shade200,
                      child: Center(
                        child: Text('$index'),
                      )));
            }))
      ],
    );
  }

  void _buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return bottomGridTiles(context);
        });
  }

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
          OpenAnswer(
              index: 0,
              text: question.options![0]!,
              press: () => _controller.checkAns(question, 0)),
          InkWell(
            onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: AlertDialog(
                        title: const Text('Heb je de vraag goed?'),
                        content: Text(question.options![0]!),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in_outlined,
                              color: Colors.green,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onPressed: () => Navigator.pop(context, "0"),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 24.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onPressed: () => Navigator.pop(context, "1"),
                          ),
                        ],
                      ),
                    )).then((x) {
              print('Pressed button!');
              if (x == null) {
                return;
              }
              print('Pressed ${x.toString()}');
              _controller.checkAns(question, int.parse(x), 1);
            }),
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                "Start Quiz",
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
