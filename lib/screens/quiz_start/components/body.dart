import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';

//import 'progress_bar.dart';
//import 'question_card.dart';

// Define a custom Form widget.// Create a Form widget.
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

// Create a corresponding State class.
// This class holds data related to the form.
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
        SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            ),
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
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 1),
                  // VRAGEN VELD
                  TextFormField(
                      controller: vragenController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: "Hoeveelheid vragen",
                          hintText: "Hoeveelheid vragen")),
                  // CATEGORIE
                  Spacer(),
                  MultiSelectDialogField(
                    buttonText: Text('Categorien'),
                    onConfirm: (val) {
                      print('Select');
                      print(val);
                      _selectedCats = val.cast<Cat>();
                    },
                    items: _items,
                    initialValue:
                        _selectedCats, // setting the value of this in initState() to pre-select values.
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          print('Quiz form ingevuld, resultaat:');
                          print(this.vragenController.text);
                          print(this._selectedCats);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Quiz Starten...')),
                          );

                          // Controller verkrijgen
                          // Vragen vervolgens updaten

                          QuestionController _controller =
                              Get.put(QuestionController());
                          _controller.updateQuestions(
                              int.parse(this.vragenController.text),
                              this._selectedCats);

                          Get.to(QuizScreen());
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ))
          ]),
        )
      ],
    );
  }
}
