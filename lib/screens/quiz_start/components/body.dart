import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter, TextInputType;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';

// TODO
// vrij lelijke klasse, het zou waardevol zijn om verschillende delen naar
// andere dart files te splitsen

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  BodyState createState() {
    return BodyState();
  }
}

class Cat {
  final int? id;
  final String? name;

  Cat({
    this.id,
    this.name,
  });
}

// Categorien
// Moeten nog aangevuld worden
class BodyState extends State<Body> {
  // List of categories
  static List<Cat> _cats = [
    Cat(id: 1, name: 'Klinische Chemie'),
    Cat(id: 2, name: 'Hematologie'),
    Cat(id: 3, name: 'Hemostase'),
    Cat(id: 4, name: 'Transfusie'),
  ];
  final List<MultiSelectItem<Cat?>> _items =
      _cats.map((c) => MultiSelectItem<Cat>(c, c.name!)).toList();
  List<Cat> _selectedCats = [];

  final TextEditingController vragenController =
      TextEditingController(text: '50');

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Stack(
      children: [
        //SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        new Container(
            decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        )),
        SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: kDefaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text.rich(
                TextSpan(
                  text: "Selecteer opties",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white70),
                ),
              ),
            ),
            Divider(thickness: 1.5),
            SizedBox(height: kDefaultPadding),
            Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding: EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // INTRODUCTIE MET SELECTIE
                          // TO-DO: introduceer auto multi-line wrap
                          Text(
                              'Selecteer hieronder welke opties u graag heeft.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
                          // SPACER
                          Spacer(),

                          // SELECTEER WELKE VRAGEN
                          TextFormField(
                              controller: vragenController,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  labelText: "Hoeveelheid vragen",
                                  labelStyle: TextStyle(color: Colors.blue),
                                  fillColor: Colors.black)),

                          // SPACER
                          Spacer(),

                          // WELKE CATEGORIEN
                          MultiSelectDialogField(
                            buttonText: Text('Selecteer categorien',
                                style: TextStyle(color: Colors.black)),
                            onConfirm: (val) {
                              print('Select');
                              print(val);
                              _selectedCats = val.cast<Cat>();
                            },
                            items: _items,
                            backgroundColor: Colors.white,
                            checkColor: Colors.black,
                            barrierColor: Colors.black,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.blue)),
                            buttonIcon: Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            initialValue:
                                _selectedCats, // setting the value of this in initState() to pre-select values.
                          ),
                          // SPACER
                          Spacer(),

                          // START NIEUWE QUIZ
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  print('Quiz form ingevuld, resultaat:');
                                  print(this.vragenController.text);
                                  print(this._selectedCats);

                                  // Controller verkrijgen
                                  // Data inladen

                                  print('Loading data');
                                  QuestionController _controller = Get.put(
                                      await QuestionController.create());

                                  print('Found questions, number: ');
                                  print(_controller.questions.length);

                                  _controller.updateQuestions(
                                      int.parse(this.vragenController.text),
                                      this._selectedCats);

                                  Get.to(QuizScreen());
                                }
                              },
                              child: const Text('Start Quiz!',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          )),
                        ],
                      ),
                    )))
          ]),
        )
      ],
    );
  }
}
