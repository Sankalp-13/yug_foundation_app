import 'package:dio/dio.dart';

import '../../domain/models/login_error_model.dart';
import '../../domain/models/profile_response_model.dart';


abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginLoadingState extends LoginState{}

class OtpVerifiedState extends LoginState{
  final ProfileResponseModel profileResponseModel;
  OtpVerifiedState(this.profileResponseModel);
}

class OtpSentState extends LoginState{
  final String otpId;
  OtpSentState(this.otpId);
}

class InvalidEmailState extends LoginState{
  final LoginError errorMsg;
  InvalidEmailState(this.errorMsg);
}

class LoginErrorState extends LoginState{
  final String error;
  LoginErrorState(this.error);
}

