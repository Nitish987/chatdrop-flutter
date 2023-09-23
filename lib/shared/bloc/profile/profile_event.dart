import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';

import '../../models/full_profile_model/full_profile_model.dart';

abstract class ProfileEvent {}

class ProfileFetchEvent extends ProfileEvent {}

class ProfileUpdateNamesEvent extends ProfileEvent {
  FullProfileModel model;
  String name;
  String username;
  ProfileUpdateNamesEvent(this.model, {required this.name, required this.username});
}

class ProfileUpdateEvent extends ProfileEvent {
  FullProfileModel model;
  String message;
  String bio;
  String interest;
  String location;
  String website;
  ProfileUpdateEvent(this.model,
      {required this.message,
      required this.bio,
      required this.interest,
      required this.location,
      required this.website});
}

class ProfilePhotoUpdateEvent extends ProfileEvent {
  FullProfileModel model;
  String imagePath;
  ProfilePhotoUpdateEvent(this.model, {required this.imagePath});
}

class ProfilePhotoSwitchEvent extends ProfileEvent {
  FullProfileModel model;
  ProfilePhotoModel profilePhoto;
  ProfilePhotoSwitchEvent(this.model, {required this.profilePhoto});
}

class ProfilePhotoDeleteEvent extends ProfileEvent {
  FullProfileModel model;
  ProfilePhotoModel profilePhoto;
  ProfilePhotoDeleteEvent(this.model, {required this.profilePhoto});
}

class ProfileCoverPhotoUpdateEvent extends ProfileEvent {
  FullProfileModel model;
  String imagePath;
  ProfileCoverPhotoUpdateEvent(this.model, {required this.imagePath});
}

class ProfileCoverPhotoSwitchEvent extends ProfileEvent {
  FullProfileModel model;
  ProfileCoverPhotoModel profileCoverPhoto;
  ProfileCoverPhotoSwitchEvent(this.model, {required this.profileCoverPhoto});
}

class ProfileCoverPhotoDeleteEvent extends ProfileEvent {
  FullProfileModel model;
  ProfileCoverPhotoModel profileCoverPhoto;
  ProfileCoverPhotoDeleteEvent(this.model, {required this.profileCoverPhoto});
}
