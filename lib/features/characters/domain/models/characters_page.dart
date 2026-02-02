import 'package:equatable/equatable.dart';

import 'character.dart';

class CharactersPage extends Equatable {
  const CharactersPage({required this.info, required this.results});

  final PageInfo info;
  final List<Character> results;

  factory CharactersPage.fromJson(Map<String, dynamic> json) {
    return CharactersPage(
      info: PageInfo.fromJson(
        (json['info'] as Map<String, dynamic>?) ?? const {},
      ),
      results: (json['results'] as List<dynamic>? ?? const [])
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [info, results];
}

class PageInfo extends Equatable {
  const PageInfo({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  final int count;
  final int pages;
  final String? next;
  final String? prev;

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      count: json['count'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }

  @override
  List<Object?> get props => [count, pages, next, prev];
}
