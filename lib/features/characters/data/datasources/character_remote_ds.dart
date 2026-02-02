import 'package:randm_concept/core/network/api_client.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/models/character_filter.dart';
import 'package:randm_concept/features/characters/domain/models/characters_page.dart';

class CharacterRemoteDataSource {
  CharacterRemoteDataSource(this._client);

  final ApiClient _client;

  Future<CharactersPage> fetchCharacters({
    required int page,
    CharacterFilter? filter,
  }) async {
    final params = <String, dynamic>{'page': page};
    if (filter != null) {
      params.addAll(filter.toQueryParameters());
    }

    final response = await _client.dio.get(
      '/character',
      queryParameters: params,
    );

    return CharactersPage.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Character> getCharacter(int id) async {
    final response = await _client.dio.get('/character/$id');
    return Character.fromJson(response.data as Map<String, dynamic>);
  }
}
