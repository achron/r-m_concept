import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expanded_character_state.dart';

class ExpandedCharacterCubit extends Cubit<ExpandedCharacterState> {
  ExpandedCharacterCubit() : super(const ExpandedCharacterState());

  void toggle(int id) {
    final nextId = state.expandedId == id ? null : id;
    emit(state.copyWith(expandedId: nextId));
  }

  void collapse() {
    if (state.expandedId == null) {
      return;
    }
    emit(state.copyWith(expandedId: null));
  }
}
