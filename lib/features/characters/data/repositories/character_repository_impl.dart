import 'package:randm_concept/features/characters/data/datasources/character_remote_ds.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/models/character_filter.dart';
import 'package:randm_concept/features/characters/domain/models/characters_page.dart';
import 'package:randm_concept/features/characters/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._remoteDataSource);

  final CharacterRemoteDataSource _remoteDataSource;

  @override
  Future<CharactersPage> getCharacters({
    required int page,
    CharacterFilter? filter,
  }) {
    return _remoteDataSource.fetchCharacters(page: page, filter: filter);
  }

  @override
  Future<Character> getCharacter(int id) {
    return _remoteDataSource.getCharacter(id);
  }
}
