import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:randm_concept/features/characters/data/datasources/character_remote_ds.dart';
import 'package:randm_concept/features/characters/data/repositories/character_repository_impl.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/models/characters_page.dart';

class _MockRemoteDataSource extends Mock
    implements CharacterRemoteDataSource {}

void main() {
  late CharacterRepositoryImpl repository;
  late _MockRemoteDataSource remote;

  setUp(() {
    remote = _MockRemoteDataSource();
    repository = CharacterRepositoryImpl(remote);
  });

  test('getCharacters возвращает данные remote', () async {
    final page = CharactersPage(
      info: const PageInfo(count: 1, pages: 1, next: null, prev: null),
      results: [_buildCharacter(1)],
    );

    when(
      () => remote.fetchCharacters(page: 1, filter: null),
    ).thenAnswer((_) async => page);

    final result = await repository.getCharacters(page: 1);

    expect(result, page);
    verify(() => remote.fetchCharacters(page: 1, filter: null)).called(1);
  });

  test('getCharacter возвращает деталь из remote', () async {
    final character = _buildCharacter(42);
    when(() => remote.getCharacter(42)).thenAnswer((_) async => character);

    final result = await repository.getCharacter(42);

    expect(result, character);
    verify(() => remote.getCharacter(42)).called(1);
  });
}

Character _buildCharacter(int id) {
  return Character(
    id: id,
    name: 'Morty',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    origin: const CharacterLocation(name: 'Earth', url: ''),
    location: const CharacterLocation(name: 'Earth', url: ''),
    image: 'https://example.com/$id.png',
    episode: const ['https://example.com/episode/1'],
    url: 'https://example.com/character/$id',
    created: DateTime(2020),
  );
}
