import '../../models/full_profile_model/full_profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileSuccessState extends ProfileState {
  final FullProfileModel profileModel;
  ProfileSuccessState(this.profileModel);
}
class ProfileFailedState extends ProfileState {
  final String error;
  ProfileFailedState(this.error);
}

class ProfileUpdateLoadingState extends ProfileState {}
class ProfileUpdateFailedState extends ProfileState {
  final String error;
  ProfileUpdateFailedState(this.error);
}

class ProfilePhotoUpdateLoadingState extends ProfileState {}
class ProfilePhotoUpdateFailedState extends ProfileState {
  final String error;
  ProfilePhotoUpdateFailedState(this.error);
}

class ProfilePhotoSwitchLoadingState extends ProfileState {}

class ProfilePhotoDeleteLoadingState extends ProfileState {}

class ProfileCoverPhotoUpdateLoadingState extends ProfileState {}
class ProfileCoverPhotoUpdateFailedState extends ProfileState {
  final String error;
  ProfileCoverPhotoUpdateFailedState(this.error);
}

class ProfileCoverPhotoSwitchLoadingState extends ProfileState {}

class ProfileCoverPhotoDeleteLoadingState extends ProfileState {}