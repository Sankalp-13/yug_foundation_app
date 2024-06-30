import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/domain/models/profile_response_model.dart';
import 'package:yug_foundation_app/providers/tasks/task_states.dart';

import '../../domain/repository/Task_repo.dart';

class TasksCubit extends Cubit<TasksState>{
  TasksCubit(): super(TasksLoadingState());
  TaskRepo tasksRepo = TaskRepo();
  final storage = const FlutterSecureStorage();

  void getTasks() async{
    try{
      emit(TasksLoadingState());
      String? token = await storage.read(key: "accessToken");
      int id = ProfileResponseModel.fromJson(jsonDecode((await storage.read(key: "profile"))!)).id!;
      Response Tasks = await tasksRepo.getTasks(token!,id);
      emit(TasksLoadedState());
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(TasksErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(TasksErrorState("Can't connect to server!"));
      }else{
        emit(TasksErrorState(ex.type.toString()));
      }
    }
  }

  // Future<void> sendAnswers(String ans) async {
  //   try{
  //     emit(TasksLoadingState());
  //     String? token = await storage.read(key: "accessToken");
  //     await TasksRepo.sendAnswer(token!,ans);
  //     List<TasksResponseModel> Tasks = await TasksRepo.getTaskss(token);
  //     emit(TasksLoadedState(Tasks));
  //   }on DioException catch(ex){
  //     if(ex.type == DioExceptionType.badResponse) {
  //       emit(TasksErrorState("Something went wrong"));
  //     }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
  //       emit(TasksErrorState("Can't connect to server!"));
  //     }else{
  //       emit(TasksErrorState(ex.type.toString()));
  //     }
  //   }
  // }

}