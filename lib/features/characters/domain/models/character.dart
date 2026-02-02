import 'package:equatable/equatable.dart';

class Character extends Equatable {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterLocation origin;
  final CharacterLocation location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      species: json['species'] as String? ?? '',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      origin: CharacterLocation.fromJson(
        (json['origin'] as Map<String, dynamic>?) ?? const {},
      ),
      location: CharacterLocation.fromJson(
        (json['location'] as Map<String, dynamic>?) ?? const {},
      ),
      image: json['image'] as String? ?? '',
      episode: (json['episode'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      url: json['url'] as String? ?? '',
      created: DateTime.tryParse(json['created'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        origin,
        location,
        image,
        episode,
        url,
        created,
      ];
}

class CharacterLocation extends Equatable {
  const CharacterLocation({required this.name, required this.url});

  final String name;
  final String url;

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [name, url];
}
