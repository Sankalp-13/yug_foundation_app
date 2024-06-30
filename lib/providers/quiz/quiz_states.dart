import 'package:yug_foundation_app/domain/models/quiz_response_model.dart';


abstract class QuizState {}

class QuizLoadingState extends QuizState {}


class QuizLoadedState extends QuizState {
  final List<QuizResponseModel> response;

  QuizLoadedState(this.response);
}

class QuizErrorState extends QuizState {
  final String error;

  QuizErrorState(this.error);
}
