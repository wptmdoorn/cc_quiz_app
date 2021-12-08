class Question {
  int? id, answer;
  String? question = "";
  String? cat = "";
  String? type = "";
  List<dynamic>? options = [];

  Question(
      {this.id, this.cat, this.type, this.question, this.answer, this.options});
}
