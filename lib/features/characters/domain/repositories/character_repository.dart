import '../models/character.dart';
import '../models/character_filter.dart';
import '../models/characters_page.dart';

abstract class CharacterRepository {
  Future<CharactersPage> getCharacters({
    required int page,
    CharacterFilter? filter,
  });

  Future<Character> getCharacter(int id);
}
