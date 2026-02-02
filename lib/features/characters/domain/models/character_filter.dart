import 'package:equatable/equatable.dart';

class CharacterFilter extends Equatable {
  const CharacterFilter({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
  });

  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (name != null && name!.trim().isNotEmpty) {
      params['name'] = name!.trim();
    }
    if (status != null && status!.trim().isNotEmpty) {
      params['status'] = status!.trim();
    }
    if (species != null && species!.trim().isNotEmpty) {
      params['species'] = species!.trim();
    }
    if (type != null && type!.trim().isNotEmpty) {
      params['type'] = type!.trim();
    }
    if (gender != null && gender!.trim().isNotEmpty) {
      params['gender'] = gender!.trim();
    }
    return params;
  }

  CharacterFilter copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) {
    return CharacterFilter(
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [name, status, species, type, gender];
}
