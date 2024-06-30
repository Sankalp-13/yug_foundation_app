import '../../domain/models/profile_response_model.dart';

abstract class ProfileState{}

class ProfileDefaultState extends ProfileState{
  final ProfileResponseModel profileResponseModel;
  ProfileDefaultState(this.profileResponseModel);
}

class ProfileLoadingState extends ProfileState{}

class ProfileUpdateState extends ProfileState{}


class ProfileErrorState extends ProfileState{
  final String error;
  ProfileErrorState(this.error);
}

