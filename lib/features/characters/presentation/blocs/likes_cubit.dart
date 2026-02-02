import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/features/characters/domain/repositories/likes_repository.dart';

part 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  LikesCubit(this._repository) : super(const LikesState());

  final LikesRepository _repository;

  Future<void> load() async {
    final ids = await _repository.loadLikedIds();
    emit(state.copyWith(likedIds: ids));
  }

  Future<void> toggleLike(int id) async {
    final ids = await _repository.toggleLike(id);
    emit(state.copyWith(likedIds: ids));
  }
}
