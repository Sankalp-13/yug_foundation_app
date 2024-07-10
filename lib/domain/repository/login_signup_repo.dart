import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yug_foundation_app/domain/models/profile_response_model.dart';

import 'api/api.dart';

class LoginRepo {
  API api = API();

  Future<Response> login(String email) async {
    var body ={
      "email": email,
    };
    try {
      Response response =
      await api.sendRequest.post("/auth/login",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<Response> otp(String otpId,int otp) async {
    var body ={
      "otpId": otpId,
      "otp": otp
    };
    try {
      Response response =
      await api.sendRequest.post("/auth/otp",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<Response> signUp(String email,int age, String birthday, String location,String gender,String contact, String picture,String name) async {
    var body ={
      "name": name,
      "age": age,
      "birthday": birthday,
      "location": location,
      "gender": gender,
      "email": email,
      "contact": contact,
      "picture": picture,
      "position": "SUPERVISOR"
    };
    try {
      Response response =
      await api.sendRequest.post("/auth/signup",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(body));
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<ProfileResponseModel> getProfile(String token) async {
    try {
      Response response =
      await api.sendRequest.get("/user",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }));

      return ProfileResponseModel.fromJson(response.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<Response> patchProfile(String email,int age, String birthday, String location,String gender,String contact, String picture,String name,String token) async {

    var body ={
      "name": name,
      "age": age,
      "birthday": birthday,
      "location": location,
      "gender": gender,
      "email": email,
      "contact": contact,
      "picture": picture,
      "position": "SUPERVISOR"
    };
    try {
      Response response =
      await api.sendRequest.patch("/user",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          }),
          data: jsonEncode(body));
      return response;
    } catch (ex) {
      rethrow;
    }
  }


}
