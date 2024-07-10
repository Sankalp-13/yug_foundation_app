import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Option {
   String? code;
   String? text;
   bool? isCorrect;

  Option({
    required this.text,
    required this.code,
    required this.isCorrect,
  });

  Option.fromJson(String ques,int codeID) {
    text = ques;
    code=(codeID+1).toString();
  }

}
