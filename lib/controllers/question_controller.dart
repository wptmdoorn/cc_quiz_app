import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:quiz_app/screens/quiz_start/components/body.dart';
import 'package:quiz_app/screens/score/score_screen.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';

// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  AnimationController? _animationController;
  late Animation _animation;
  // so that we can access our animation outside
  Animation get animation => this._animation;

  late PageController _pageController;
  PageController get pageController => this._pageController;

  late List<Question> _questions;
  List<Question> get questions => this._questions;
  //List<Question> set questions => this.getQuestions();

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  late int? _correctAns;
  int? get correctAns => this._correctAns;

  late int? _selectedAns;
  int? get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    print('lets init');
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController?.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    //getQuestions().then((v) {
    //   this._questions = v;
    //});
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _animationController?.dispose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex, [int duration = 3]) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer!;
    _selectedAns = selectedIndex;

    print('Checking answer');
    print('Selected answer: ${_selectedAns}');
    print('Correct answer: ${_correctAns}');

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    _animationController?.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: duration), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    print('Nexttttt');
    print(this.questions.length);
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController?.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController?.forward().whenComplete(nextQuestion);
    } else {
      // Get package provide us simple way to naviigate another page
      Get.to(ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }

  Future<List<Question>> getQuestions() async {
    print('Loading questions');
    ByteData data = await rootBundle.load("assets/Masterfile KC QUIZ APP.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    List questions = [];
    List<List<Data?>>? table = excel.tables['Blad1']!.rows.sublist(1);

    for (var row in table) {
      try {
        questions.add({
          "id": row[0] == null ? 0 : row[0]?.value,
          'cat': row[1]?.value,
          'question_type': row[2]?.value,
          'question': row[4]?.value,
          'options': [
            row[6] == null ? "" : row[6]?.value.toString(),
            row[7] == null ? "" : row[7]?.value.toString(),
            row[8] == null ? "" : row[8]?.value.toString(),
            row[9] == null ? "" : row[9]?.value.toString(),
          ],
          'answer_index': row[10] == null
              ? 0
              : int.parse(row[10]?.value.substring(1, 2)) - 1,
        });
      } catch (e) {
        //TODO: REMOVE EMPTY QUESTIONS
        //print(e);
        //print('typeerorr');
      }
    }

    List<Question> final_questions = questions
        .map(
          (question) => Question(
              id: question['id'],
              cat: question['cat'],
              type: question['question_type'],
              question: question['question'],
              options: question['options'],
              answer: question['answer_index']),
        )
        .toList();

    print('Found questions, number:');
    print(final_questions.length);

    _questions = final_questions;

    return final_questions;
  }

  updateQuestions(int? maximum, List<Cat> cats) {
    print('Updating questions...');
    List<String> cat_names = cats.map((c) => c.name!).toList();
    print(cat_names);

    print('Filtering questions..');
    List<Question> filteredQuestions =
        questions.where((i) => cat_names.contains(i.cat)).toList();

    print('List size after filtering: ');
    print(filteredQuestions.length);

    // Shuffle list
    filteredQuestions.shuffle();

    // Slice list
    filteredQuestions = filteredQuestions.sublist(0, maximum);

    this._questions = filteredQuestions;
  }

  static Future<QuestionController> create() async {
    print('Initializing question controller');
    QuestionController _qc = QuestionController();
    await _qc.getQuestions();
    return _qc;
  }
}
