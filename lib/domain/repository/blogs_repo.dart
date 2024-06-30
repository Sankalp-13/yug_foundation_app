import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/blogs_response_model.dart';

import 'api/api.dart';

class BlogsRepo {
  API api = API();


  Future<BlogsResponseModel> getBlogs(String token) async {
    try {
      Response response =
      await api.sendRequest.get("/blog?region=general",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return BlogsResponseModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

}