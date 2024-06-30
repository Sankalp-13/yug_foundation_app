import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/domain/models/quiz_response_model.dart';
import 'package:yug_foundation_app/providers/Quiz/Quiz_states.dart';
import '../../domain/repository/Quiz_repo.dart';

class QuizCubit extends Cubit<QuizState>{
  QuizCubit(): super(QuizLoadingState());
  final storage = const FlutterSecureStorage();

  QuizRepo quizRepo = QuizRepo();

  void getQuiz() async{
    try{
      emit(QuizLoadingState());
      // String? token = await storage.read(key: "accessToken");
      List<QuizResponseModel> Quiz = await quizRepo.getQuiz();
      emit(QuizLoadedState(Quiz));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(QuizErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(QuizErrorState("Can't connect to server!"));
      }else{
        emit(QuizErrorState(ex.type.toString()));
      }
    }
  }
}