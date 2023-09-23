import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/profile_cover_photo_model/profile_cover_photo_model.dart';
import 'package:chatdrop/shared/models/profile_model/profile_model.dart';
import 'package:chatdrop/shared/models/profile_photo_model/profile_photo_model.dart';

import '../models/full_profile_model/full_profile_model.dart';
import '../repository/profile_repo.dart';

class ProfileService {
  final ProfileRepository _profileRepository = ProfileRepository.instance;

  Future<FullProfileModel?> fetchProfile() async {
    try {
      final response =
          ResponseCollector.collect(await _profileRepository.getProfile());
      if (response.success) {
        FullProfileModel model = FullProfileModel.fromJson(response.data!);
        return model;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ProfileModel?> updateProfile(
      {String message = '',
      String bio = '',
      String interest = '',
      String location = '',
      String website = ''}) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.updateProfile(
          message: message,
          bio: bio,
          interest: interest,
          location: location,
          website: website,
        ),
      );
      if (response.success) {
        ProfileModel model = ProfileModel.fromJson(response.data!['profile']);
        return model;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ProfilePhotoModel?> updateProfilePhoto(imagePath) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.updateProfilePhoto(imagePath),
      );
      if (response.success) {
        ProfilePhotoModel profilePhoto = ProfilePhotoModel.fromJson(response.data!);
        return profilePhoto;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> switchProfilePhoto(id) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.switchProfilePhoto(id),
      );
      if (response.success) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProfilePhoto(id) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.deleteProfilePhoto(id),
      );
      if (response.success) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ProfileCoverPhotoModel?> updateProfileCoverPhoto(imagePath) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.updateProfileCoverPhoto(imagePath),
      );
      if (response.success) {
        ProfileCoverPhotoModel profileCoverPhoto = ProfileCoverPhotoModel.fromJson(response.data!);
        return profileCoverPhoto;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> switchProfileCoverPhoto(id) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.switchProfileCoverPhoto(id),
      );
      if (response.success) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProfileCoverPhoto(id) async {
    try {
      final response = ResponseCollector.collect(
        await _profileRepository.deleteProfileCoverPhoto(id),
      );
      if (response.success) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
