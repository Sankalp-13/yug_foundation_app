import '../../domain/models/survey_response_model.dart';

abstract class SurveyHomeState {}

class SurveyHomeLoadingState extends SurveyHomeState {}

class SurveyAnswerSentState extends SurveyHomeState {}

class SurveyHomeLoadedState extends SurveyHomeState {
  final List<SurveyResponseModel> response;

  SurveyHomeLoadedState(this.response);
}

class SurveyHomeErrorState extends SurveyHomeState {
  final String error;

  SurveyHomeErrorState(this.error);
}
