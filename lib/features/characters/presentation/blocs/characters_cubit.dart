import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/models/character_filter.dart';
import 'package:randm_concept/features/characters/domain/models/characters_page.dart';
import 'package:randm_concept/features/characters/domain/repositories/character_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this._repository) : super(const CharactersState());

  final CharacterRepository _repository;
  CharacterFilter? _filter;
  int _page = 1;
  bool _isLoadingMore = false;

  Future<void> fetchFirstPage({CharacterFilter? filter}) async {
    _filter = filter;
    _page = 1;
    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        errorMessage: null,
        isLoadingMore: false,
      ),
    );

    try {
      final page = await _repository.getCharacters(page: _page, filter: _filter);
      emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: page.results,
          pageInfo: page.info,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CharactersStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore || state.status != CharactersStatus.success) {
      return;
    }

    final hasMore = state.pageInfo?.next != null;
    if (!hasMore) {
      return;
    }

    _isLoadingMore = true;
    emit(state.copyWith(isLoadingMore: true));
    _page += 1;

    try {
      final page = await _repository.getCharacters(page: _page, filter: _filter);
      final updated = List<Character>.from(state.characters)
        ..addAll(page.results);
      emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: updated,
          pageInfo: page.info,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          errorMessage: error.toString(),
          isLoadingMore: false,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}
