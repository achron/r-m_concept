import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:randm_concept/features/characters/domain/repositories/likes_repository.dart';
import 'package:randm_concept/features/characters/presentation/blocs/likes_cubit.dart';

class _MockLikesRepository extends Mock implements LikesRepository {}

void main() {
  late LikesRepository repository;

  setUp(() {
    repository = _MockLikesRepository();
  });

  blocTest<LikesCubit, LikesState>(
    'load загружает likedIds',
    build: () {
      when(() => repository.loadLikedIds())
          .thenAnswer((_) async => {1, 2});
      return LikesCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [const LikesState(likedIds: {1, 2})],
  );

  blocTest<LikesCubit, LikesState>(
    'toggleLike обновляет состояние',
    build: () {
      when(() => repository.toggleLike(10))
          .thenAnswer((_) async => {10});
      return LikesCubit(repository);
    },
    act: (cubit) => cubit.toggleLike(10),
    expect: () => [const LikesState(likedIds: {10})],
  );
}
