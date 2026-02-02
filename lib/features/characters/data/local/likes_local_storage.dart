import 'package:hive/hive.dart';

class LikesLocalStorage {
  LikesLocalStorage({Future<Box<dynamic>>? boxFuture})
      : _boxFuture = boxFuture ?? Hive.openBox<dynamic>(_boxName);

  static const String _boxName = 'likes';
  static const String _key = 'liked_ids';

  final Future<Box<dynamic>> _boxFuture;

  Future<Set<int>> loadLikedIds() async {
    final box = await _boxFuture;
    final stored = box.get(_key, defaultValue: <int>[]) as List<dynamic>;
    return stored.map((e) => e as int).toSet();
  }

  Future<void> saveLikedIds(Set<int> ids) async {
    final box = await _boxFuture;
    await box.put(_key, ids.toList());
  }
}
