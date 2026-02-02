part of 'expanded_character_cubit.dart';

class ExpandedCharacterState extends Equatable {
  const ExpandedCharacterState({this.expandedId});

  final int? expandedId;

  ExpandedCharacterState copyWith({int? expandedId}) {
    return ExpandedCharacterState(expandedId: expandedId);
  }

  @override
  List<Object?> get props => [expandedId];
}
