import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/full_profile_model/full_profile_model.dart';
import '../../services/profile_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService = ProfileService();

  ProfileBloc() : super(ProfileInitialState()) {
    fetchProfileEvent();
    updateProfileNamesEvent();
    updateProfileEvent();
    updateProfilePhotoEvent();
    switchProfilePhotoEvent();
    deleteProfilePhotoEvent();
    updateProfileCoverPhotoEvent();
    switchProfileCoverPhotoEvent();
    deleteProfileCoverPhotoEvent();
  }

  void fetchProfileEvent() {
    on<ProfileFetchEvent>((event, emit) async {
      emit(ProfileLoadingState());
      FullProfileModel? model = await _profileService.fetchProfile();
      if (model == null) {
        emit(ProfileFailedState('Unable to Load Profile.'));
      } else {
        emit(ProfileSuccessState(model));
      }
    });
  }

  void updateProfileNamesEvent() {
    on<ProfileUpdateNamesEvent>((event, emit) async {
      FullProfileModel model = event.model;
      model.profile!.name = event.name;
      model.profile!.username = event.username;
      emit(ProfileSuccessState(model));
    });
  }

  void updateProfileEvent() {
    on<ProfileUpdateEvent>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      if (event.message.isEmpty) event.message = '';
      if (event.bio.isEmpty) event.bio = '';
      if (event.message.isEmpty) event.interest = '';
      if (event.message.isEmpty) event.location = '';
      if (event.message.isEmpty) event.website = '';

      if (event.message.length > 100) {
        emit(ProfileUpdateFailedState('Message must be of 100 characters'));
      } else if (event.bio.length > 2000) {
        emit(ProfileUpdateFailedState('Bio must be of 2000 characters'));
      } else if (!event.website.startsWith('https://') && event.website.isNotEmpty) {
        emit(ProfileUpdateFailedState('Website link should start with https://'));
      } else {
        ProfileModel? profile = await _profileService.updateProfile(
          message: event.message,
          bio: event.bio,
          interest: event.interest,
          location: event.location,
          website: event.website,
        );
        if (profile == null) {
          emit(ProfileUpdateFailedState('Unable to update Profile.'));
        } else {
          event.model.profile = profile;
          emit(ProfileSuccessState(event.model));
        }
      }
    });
  }

  void updateProfilePhotoEvent() {
    on<ProfilePhotoUpdateEvent>((event, emit) async {
      emit(ProfilePhotoUpdateLoadingState());
      ProfilePhotoModel? profilePhoto =
          await _profileService.updateProfilePhoto(event.imagePath);
      if (profilePhoto == null) {
        emit(ProfilePhotoUpdateFailedState('Unable to update Profile Pic.'));
      } else {
        event.model.profile?.photo = profilePhoto.photo;
        event.model.profilePhotos?.add(
          ProfilePhotoModel(
            id: profilePhoto.id,
            photo: profilePhoto.photo,
          ),
        );
        emit(ProfileSuccessState(event.model));
      }
    });
  }

  void switchProfilePhotoEvent() {
    on<ProfilePhotoSwitchEvent>((event, emit) async {
      emit(ProfilePhotoSwitchLoadingState());
      bool success =
          await _profileService.switchProfilePhoto(event.profilePhoto.id);
      if (success) {
        event.model.profile?.photo = event.profilePhoto.photo;
      }
      emit(ProfileSuccessState(event.model));
    });
  }

  void deleteProfilePhotoEvent() {
    on<ProfilePhotoDeleteEvent>((event, emit) async {
      emit(ProfilePhotoDeleteLoadingState());
      bool success =
          await _profileService.deleteProfilePhoto(event.profilePhoto.id);
      if (success) {
        event.model.profilePhotos = event.model.profilePhotos
            ?.where((element) => element.id != event.profilePhoto.id)
            .toList();
        if (event.model.profile?.photo == event.profilePhoto.photo) {
          event.model.profile?.photo = '';
        }
      }
      emit(ProfileSuccessState(event.model));
    });
  }

  void updateProfileCoverPhotoEvent() {
    on<ProfileCoverPhotoUpdateEvent>((event, emit) async {
      emit(ProfileCoverPhotoUpdateLoadingState());
      ProfileCoverPhotoModel? coverPhoto =
          await _profileService.updateProfileCoverPhoto(event.imagePath);
      if (coverPhoto == null) {
        emit(ProfileCoverPhotoUpdateFailedState(
            'Unable to update Profile Pic.'));
      } else {
        event.model.profile?.coverPhoto = coverPhoto.cover;
        event.model.profileCoverPhotos?.add(
          ProfileCoverPhotoModel(
            id: coverPhoto.id,
            cover: coverPhoto.cover,
          ),
        );
        emit(ProfileSuccessState(event.model));
      }
    });
  }

  void switchProfileCoverPhotoEvent() {
    on<ProfileCoverPhotoSwitchEvent>((event, emit) async {
      emit(ProfileCoverPhotoSwitchLoadingState());
      bool success = await _profileService
          .switchProfileCoverPhoto(event.profileCoverPhoto.id);
      if (success) {
        event.model.profile?.coverPhoto = event.profileCoverPhoto.cover;
      }
      emit(ProfileSuccessState(event.model));
    });
  }

  void deleteProfileCoverPhotoEvent() {
    on<ProfileCoverPhotoDeleteEvent>((event, emit) async {
      emit(ProfileCoverPhotoDeleteLoadingState());
      bool success = await _profileService
          .deleteProfileCoverPhoto(event.profileCoverPhoto.id);
      if (success) {
        event.model.profileCoverPhotos = event.model.profileCoverPhotos
            ?.where((element) => element.id != event.profileCoverPhoto.id)
            .toList();
        if (event.model.profile?.coverPhoto == event.profileCoverPhoto.cover) {
          event.model.profile?.coverPhoto = '';
        }
      }
      emit(ProfileSuccessState(event.model));
    });
  }
}
