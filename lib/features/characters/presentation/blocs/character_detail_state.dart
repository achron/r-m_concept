part of 'character_detail_cubit.dart';

enum CharacterDetailStatus { initial, loading, success, failure }

class CharacterDetailState extends Equatable {
  const CharacterDetailState({
    this.status = CharacterDetailStatus.initial,
    this.character,
    this.errorMessage,
  });

  final CharacterDetailStatus status;
  final Character? character;
  final String? errorMessage;

  CharacterDetailState copyWith({
    CharacterDetailStatus? status,
    Character? character,
    String? errorMessage,
  }) {
    return CharacterDetailState(
      status: status ?? this.status,
      character: character ?? this.character,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, character, errorMessage];
}
