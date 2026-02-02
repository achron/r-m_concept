abstract class LikesRepository {
  Future<Set<int>> loadLikedIds();
  Future<Set<int>> toggleLike(int id);
}
