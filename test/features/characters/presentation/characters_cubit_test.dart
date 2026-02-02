import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/models/character_filter.dart';
import 'package:randm_concept/features/characters/domain/models/characters_page.dart';
import 'package:randm_concept/features/characters/domain/repositories/character_repository.dart';
import 'package:randm_concept/features/characters/presentation/blocs/characters_cubit.dart';

class _MockCharacterRepository extends Mock implements CharacterRepository {}

class _FakeCharacterFilter extends Fake implements CharacterFilter {}

void main() {
  late CharacterRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeCharacterFilter());
  });

  setUp(() {
    repository = _MockCharacterRepository();
  });

  blocTest<CharactersCubit, CharactersState>(
    'fetchFirstPage эмитит loading и success',
    build: () {
      when(
        () => repository.getCharacters(page: 1, filter: any(named: 'filter')),
      ).thenAnswer(
        (_) async => CharactersPage(
          info: const PageInfo(count: 1, pages: 1, next: null, prev: null),
          results: [_buildCharacter(1)],
        ),
      );
      return CharactersCubit(repository);
    },
    act: (cubit) => cubit.fetchFirstPage(),
    expect: () => [
      const CharactersState(status: CharactersStatus.loading),
      CharactersState(
        status: CharactersStatus.success,
        characters: [_buildCharacter(1)],
        pageInfo: const PageInfo(count: 1, pages: 1, next: null, prev: null),
      ),
    ],
  );

  blocTest<CharactersCubit, CharactersState>(
    'fetchFirstPage эмитит failure при ошибке',
    build: () {
      when(
        () => repository.getCharacters(page: 1, filter: any(named: 'filter')),
      ).thenThrow(Exception('boom'));
      return CharactersCubit(repository);
    },
    act: (cubit) => cubit.fetchFirstPage(),
    expect: () => [
      const CharactersState(status: CharactersStatus.loading),
      const CharactersState(
        status: CharactersStatus.failure,
        errorMessage: 'Exception: boom',
      ),
    ],
  );
}

Character _buildCharacter(int id) {
  return Character(
    id: id,
    name: 'Rick',
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
