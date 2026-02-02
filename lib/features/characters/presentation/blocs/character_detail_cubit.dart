import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/domain/repositories/character_repository.dart';

part 'character_detail_state.dart';

class CharacterDetailCubit extends Cubit<CharacterDetailState> {
  CharacterDetailCubit(this._repository)
      : super(const CharacterDetailState());

  final CharacterRepository _repository;

  Future<void> loadCharacter(int id) async {
    emit(state.copyWith(status: CharacterDetailStatus.loading));

    try {
      final character = await _repository.getCharacter(id);
      emit(
        state.copyWith(
          status: CharacterDetailStatus.success,
          character: character,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CharacterDetailStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
