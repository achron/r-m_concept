import 'package:flutter_bloc/flutter_bloc.dart';

class ViewedStoriesState {
  const ViewedStoriesState({this.viewedIds = const <int>{}});

  final Set<int> viewedIds;

  ViewedStoriesState copyWith({Set<int>? viewedIds}) {
    return ViewedStoriesState(viewedIds: viewedIds ?? this.viewedIds);
  }
}

class ViewedStoriesCubit extends Cubit<ViewedStoriesState> {
  ViewedStoriesCubit() : super(const ViewedStoriesState());

  void markViewed(int characterId) {
    if (state.viewedIds.contains(characterId)) {
      return;
    }

    final updated = Set<int>.from(state.viewedIds)..add(characterId);
    emit(state.copyWith(viewedIds: updated));
  }

  void reset() {
    emit(const ViewedStoriesState());
  }
}