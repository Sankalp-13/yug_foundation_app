import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_states.dart';

import '../../domain/models/survey_response_model.dart';
import '../../domain/repository/survey_repo.dart';

class SurveyHomeCubit extends Cubit<SurveyHomeState>{
  SurveyHomeCubit(): super(SurveyHomeLoadingState());
  SurveyRepo surveyRepo = SurveyRepo();
  final storage = const FlutterSecureStorage();

  void getSurveyHome() async{
    try{
      emit(SurveyHomeLoadingState());

      String? token = await storage.read(key: "accessToken");
      List<SurveyResponseModel> surveyHome = await surveyRepo.getSurveys(token!);
      emit(SurveyHomeLoadedState(surveyHome));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(SurveyHomeErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(SurveyHomeErrorState("Can't connect to server!"));
      }else{
        emit(SurveyHomeErrorState(ex.type.toString()));
      }
    }
  }

  Future<void> sendAnswers(String ans) async {
    try{
      emit(SurveyHomeLoadingState());
      String? token = await storage.read(key: "accessToken");
      await surveyRepo.sendAnswer(token!,ans);
      List<SurveyResponseModel> surveyHome = await surveyRepo.getSurveys(token);
      emit(SurveyHomeLoadedState(surveyHome));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(SurveyHomeErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(SurveyHomeErrorState("Can't connect to server!"));
      }else{
        emit(SurveyHomeErrorState(ex.type.toString()));
      }
    }
  }

}