import 'package:yug_foundation_app/domain/models/option.dart';

class QuizResponseModel {
  String? topic;
  String? created;
  List<Questions>? questions;

  QuizResponseModel({this.topic, this.created, this.questions});

  QuizResponseModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    created = json['created'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['created'] = this.created;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? text;
  String? type;
  String? correctAnswer;
  List<Option>? options;
  bool isLocked = false;
  Option? selectedOption;

  Questions(
      {this.text,
      this.type,
      this.correctAnswer,
      this.options,
      this.isLocked = false,this.selectedOption});

  Questions.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
    correctAnswer = json['correctAnswer'];
    // options = json['options'].cast<String>();
    if (json['options'] != null) {
      options = <Option>[];
      int code = 0;
      json['options'].forEach((v) {
        options!.add(new Option.fromJson(v,code));
        code++;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['type'] = this.type;
    data['correctAnswer'] = this.correctAnswer;
    data['options'] = this.options;
    return data;
  }
}
