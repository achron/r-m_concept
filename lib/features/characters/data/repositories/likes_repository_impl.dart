import 'package:randm_concept/features/characters/data/local/likes_local_storage.dart';
import 'package:randm_concept/features/characters/domain/repositories/likes_repository.dart';

class LikesRepositoryImpl implements LikesRepository {
  LikesRepositoryImpl(this._localStorage);

  final LikesLocalStorage _localStorage;
  Set<int> _cache = <int>{};

  @override
  Future<Set<int>> loadLikedIds() async {
    _cache = await _localStorage.loadLikedIds();
    return _cache;
  }

  @override
  Future<Set<int>> toggleLike(int id) async {
    if (_cache.isEmpty) {
      _cache = await _localStorage.loadLikedIds();
    }

    if (_cache.contains(id)) {
      _cache.remove(id);
    } else {
      _cache.add(id);
    }

    await _localStorage.saveLikedIds(_cache);
    return _cache;
  }
}
