class SurveyAnswerRequestModel {
  List<Answers>? answers;

  SurveyAnswerRequestModel({this.answers});

  SurveyAnswerRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? questionId;
  String? response;

  Answers({this.questionId, this.response});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['response'] = this.response;
    return data;
  }
}
