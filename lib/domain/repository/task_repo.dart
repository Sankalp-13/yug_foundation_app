import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:yug_foundation_app/domain/models/Task_response_model.dart';

import 'api/api.dart';

class TaskRepo {
  API api = API();


  Future<Response> getTasks(String token,int id) async {
    try {
      Response response =
      await api.sendRequest.get("/tasks/fetch/$id",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return response;
    } catch (ex) {
      rethrow;
    }
  }


  Future<Response> sendAnswer(String token,String ans) async {

    var body = ans;

    try {
      Response response =
      await api.sendRequest.post("/Task/Taskresponse",
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