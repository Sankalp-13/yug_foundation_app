class SurveyResponseModel {
  int? id;
  String? topic;
  String? description;
  List<Questions>? questions;

  SurveyResponseModel({this.id, this.topic, this.description, this.questions});

  SurveyResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    description = json['description'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['description'] = this.description;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  List<String>? options;
  String? text;
  String? type;
  int? id;

  Questions({this.options, this.text, this.type, this.id});

  Questions.fromJson(Map<String, dynamic> json) {
    options = json['options'].cast<String>();
    text = json['text'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['options'] = this.options;
    data['text'] = this.text;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}
