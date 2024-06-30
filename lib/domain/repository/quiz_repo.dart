import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/quiz_response_model.dart';

import 'api/api.dart';

class QuizRepo {
  API api = API();


  Future<List<QuizResponseModel>> getQuiz() async {
    try {
      Response response =
      await api.sendRequest.get("/quiz",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            // HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return (response.data as List)
          .map((x) => QuizResponseModel.fromJson(x))
          .toList();

    } catch (ex) {
      rethrow;
    }
  }
}