import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/login_error_model.dart';
import '../../domain/models/profile_response_model.dart';
import '../../domain/repository/login_signup_repo.dart';
import 'login_signup_state.dart';


class LoginCubit extends Cubit<LoginState>{
  LoginCubit(): super(LoginInitialState());
  final storage = const FlutterSecureStorage();
  LoginRepo loginRepo = LoginRepo();
  String tempEmail="";

  void login(String email) async{
    try{
      emit(LoginLoadingState());
      Response response = await loginRepo.login(email);
      emit(OtpSentState(response.data['otpId']));
      tempEmail = email;
    }on DioException catch(ex){
      if(ex.response?.statusCode==500){
        // LoginError.fromJson(ex.response?.data);
        // if (ex.response!.data["message"].length==1) {
        //   emit(InvalidEmailState(LoginError.fromJson(ex.response?.data)));
        // }else{
          emit(InvalidEmailState("No user found! Please Sign up!"));
        // }

      }else if(ex.type == DioExceptionType.badResponse) {
        emit(LoginErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(LoginErrorState("Can't connect!"));
      }else{
        emit(LoginErrorState(ex.type.toString()));
      }
    }
  }


  void signUp(String email,int age, String birthday, String location,String gender,String contact, String picture,String name) async{
    try{
      emit(LoginLoadingState());
      Response response = await loginRepo.signUp(email,age,birthday,location,gender.toUpperCase(),contact,picture,name);
      emit(OtpSentState(response.data['otpId']));
      tempEmail = email;
    }on DioException catch(ex){
      if(ex.response?.statusCode==401||ex.response?.statusCode==400){
          emit(InvalidEmailState(ex.response!.data["message"]["message"][0]));
      }else if(ex.type == DioExceptionType.badResponse) {
        emit(LoginErrorState("User Already Exists!"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(LoginErrorState("Can't connect!"));
      }else{
        emit(LoginErrorState(ex.type.toString()));
      }
    }
  }


  void verifyOtp(String otpId,int otp) async{
    try{
      emit(LoginLoadingState());
      Response response=await loginRepo.otp(otpId,otp);
      await storage.write(key: 'accessToken', value: response.data["accessToken"]);
      await storage.write(key: 'refreshToken', value: response.data["refreshToken"]);
      ProfileResponseModel profileResponseModel = await loginRepo.getProfile(response.data['accessToken']);
      await storage.write(key: 'profile', value: jsonEncode(profileResponseModel.toJson()));
      emit(OtpVerifiedState(profileResponseModel));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(LoginErrorState("Invalid OTP"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(LoginErrorState("Can't connect!"));
      }else{
        emit(LoginErrorState(ex.type.toString()));
      }
    }
  }

}


