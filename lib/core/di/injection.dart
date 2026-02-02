import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:randm_concept/core/network/network.dart';
import 'package:randm_concept/features/characters/data/data.dart';
import 'package:randm_concept/features/characters/domain/domain.dart';
import 'package:randm_concept/features/characters/presentation/presentation.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (!getIt.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(ApiClient.new);
  }

  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => getIt<ApiClient>().dio);
  }

  if (!getIt.isRegistered<CharacterRemoteDataSource>()) {
    getIt.registerLazySingleton<CharacterRemoteDataSource>(
      () => CharacterRemoteDataSource(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<CharacterRepository>()) {
    getIt.registerLazySingleton<CharacterRepository>(
      () => CharacterRepositoryImpl(getIt<CharacterRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<LikesLocalStorage>()) {
    getIt.registerLazySingleton<LikesLocalStorage>(LikesLocalStorage.new);
  }

  if (!getIt.isRegistered<LikesRepository>()) {
    getIt.registerLazySingleton<LikesRepository>(
      () => LikesRepositoryImpl(getIt<LikesLocalStorage>()),
    );
  }

  if (!getIt.isRegistered<CharactersCubit>()) {
    getIt.registerFactory<CharactersCubit>(
      () => CharactersCubit(getIt<CharacterRepository>()),
    );
  }

  if (!getIt.isRegistered<CharacterDetailCubit>()) {
    getIt.registerFactory<CharacterDetailCubit>(
      () => CharacterDetailCubit(getIt<CharacterRepository>()),
    );
  }

  if (!getIt.isRegistered<LikesCubit>()) {
    getIt.registerFactory<LikesCubit>(
      () => LikesCubit(getIt<LikesRepository>()),
    );
  }
}
