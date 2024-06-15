class SurveyResponseModel {
  int? status;
  List<Data>? data;

  SurveyResponseModel({this.status, this.data});

  SurveyResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? topic;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? userId;
  List<Questions>? questions;

  Data(
      {this.id,
        this.topic,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topic = json['topic'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? text;
  String? type;
  String? correctAnswer;
  String? createdAt;
  String? updatedAt;
  int? surveyId;

  Questions(
      {this.id,
        this.text,
        this.type,
        this.correctAnswer,
        this.createdAt,
        this.updatedAt,
        this.surveyId});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    type = json['type'];
    correctAnswer = json['correctAnswer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    surveyId = json['surveyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['type'] = this.type;
    data['correctAnswer'] = this.correctAnswer;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['surveyId'] = this.surveyId;
    return data;
  }
}
