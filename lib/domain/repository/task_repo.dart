import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/task_response_model.dart';

import 'api/api.dart';

class TaskRepo {
  API api = API();


  Future<TasksResponseModel> getTasks(String token,int id) async {
    try {
      Response response =
      await api.sendRequest.get("/tasks/fetch/$id",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return TasksResponseModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }


  Future<Response> completeTask(String token,int id) async {
    print("/tasks/$id");
    var body = {
      "status": "COMPLETED"
    };

    try {
      Response response =
      await api.sendRequest.patch("/tasks/$id",
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