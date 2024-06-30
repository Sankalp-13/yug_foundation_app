import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/survey_response_model.dart';

import 'api/api.dart';

class SurveyRepo {
  API api = API();


  Future<List<SurveyResponseModel>> getSurveys(String token) async {
    try {
      Response response =
      await api.sendRequest.get("/survey/universe",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return (response.data as List)
          .map((x) => SurveyResponseModel.fromJson(x))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }


  Future<Response> sendAnswer(String token,String ans) async {

    var body = ans;

    try {
      Response response =
      await api.sendRequest.post("/survey/surveyresponse",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }),
          data: body);
      return response;
    } catch (ex) {
      rethrow;
    }
  }



}