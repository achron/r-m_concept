part of 'characters_cubit.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const <Character>[],
    this.pageInfo,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final CharactersStatus status;
  final List<Character> characters;
  final PageInfo? pageInfo;
  final bool isLoadingMore;
  final String? errorMessage;

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    PageInfo? pageInfo,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      pageInfo: pageInfo ?? this.pageInfo,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        pageInfo,
        isLoadingMore,
        errorMessage,
      ];
}
