import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/survey_response_model.dart';

import 'api/api.dart';

class SurveyRepo {
  API api = API();


  Future<SurveyResponseModel> getSurveys() async {
    try {
      Response response =
      await api.sendRequest.get("/survey",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      return SurveyResponseModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

}