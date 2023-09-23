import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/models/audio_model/audio_model.dart';
import 'package:chatdrop/shared/models/user_model/user_model.dart';
import '../repository/search_repo.dart';

class SearchService {
  final SearchRepository _searchRepository = SearchRepository.instance;

  Future<List<UserModel>?> searchProfiles(String query, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _searchRepository.searchProfiles(query, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['result'];
        List<UserModel> searchProfiles = result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        return searchProfiles;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }

  Future<List<AudioModel>?> searchAudios(String query, {int page = 1}) async {
    try {
      final response = ResponseCollector.collect(
        await _searchRepository.searchAudios(query, page: page),
      );
      if (response.success) {
        List<dynamic> result = response.data?['result'];
        List<AudioModel> searchAudios = result.map((e) => AudioModel.fromJson(e as Map<String, dynamic>)).toList();
        return searchAudios;
      } else {
        return null;
      }
    } catch(e) {
      return null;
    }
  }
}