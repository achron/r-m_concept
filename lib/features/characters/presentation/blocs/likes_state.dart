part of 'likes_cubit.dart';

class LikesState extends Equatable {
  const LikesState({this.likedIds = const <int>{}});

  final Set<int> likedIds;

  LikesState copyWith({Set<int>? likedIds}) {
    return LikesState(likedIds: likedIds ?? this.likedIds);
  }

  @override
  List<Object?> get props => [likedIds];
}
