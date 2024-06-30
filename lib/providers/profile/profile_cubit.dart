import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/domain/repository/login_signup_repo.dart';
import 'package:yug_foundation_app/providers/profile/profile_states.dart';
import '../../domain/models/profile_response_model.dart';


class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit(): super(ProfileLoadingState());
  final storage = const FlutterSecureStorage();
  LoginRepo loginRepo = LoginRepo();




  void getProfile() async{
    try{
      emit(ProfileLoadingState());
      ProfileResponseModel profileResponseModel = ProfileResponseModel.fromJson(jsonDecode((await storage.read(key: "profile"))!));
      emit(ProfileDefaultState(profileResponseModel));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(ProfileErrorState("Invalid OTP"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(ProfileErrorState("Can't connect!"));
      }else{
        emit(ProfileErrorState(ex.type.toString()));
      }
    }
  }

  void updateProfileState(){
    emit(ProfileUpdateState());
  }

  void sendUpdatedProfile(String email,int age, String birthday, String location,String gender,String contact, String picture,String name) async{
    try{
      emit(ProfileLoadingState());
      String? token = await storage.read(key: "accessToken");
      Response response = await loginRepo.patchProfile(email,age,birthday,location,gender.toUpperCase(),contact,picture,name,token!);
      ProfileResponseModel profileResponseModel = ProfileResponseModel.fromJson(jsonDecode((await storage.read(key: "profile"))!));
      emit(ProfileDefaultState(profileResponseModel));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(ProfileErrorState("Invalid OTP"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(ProfileErrorState("Can't connect!"));
      }else{
        emit(ProfileErrorState(ex.type.toString()));
      }
    }
  }
}





