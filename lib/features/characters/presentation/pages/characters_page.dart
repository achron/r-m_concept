import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/core/theme/theme_cubit.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/presentation/blocs/characters_cubit.dart';
import 'package:randm_concept/features/characters/presentation/blocs/expanded_character_cubit.dart';
import 'package:randm_concept/features/characters/presentation/blocs/viewed_stories_cubit.dart';
import 'package:randm_concept/features/characters/presentation/pages/character_modal.dart';
import 'package:randm_concept/features/characters/presentation/pages/story_viewer.dart';
import 'package:randm_concept/features/characters/presentation/widgets/character_card.dart';
import 'package:randm_concept/features/characters/presentation/widgets/story_widget.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final cubit = context.read<CharactersCubit>();
    final hasMore = cubit.state.pageInfo?.next != null;
    final isLoading = cubit.state.isLoadingMore;

    if (!hasMore || isLoading) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 240;
    if (_scrollController.position.pixels >= threshold) {
      cubit.fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<ThemeCubit, bool>(
      (cubit) => cubit.state == ThemeMode.dark,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExpandedCharacterCubit()),
        BlocProvider(create: (_) => ViewedStoriesCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty'),
          actions: [
            IconButton(
              onPressed: () => context.read<ThemeCubit>().toggle(),
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Сменить тему',
            ),
          ],
        ),
        body: BlocBuilder<CharactersCubit, CharactersState>(
          builder: (context, state) {
            if (state.status == CharactersStatus.loading &&
                state.characters.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CharactersStatus.failure) {
              return _ErrorState(
                message: state.errorMessage ?? 'Не удалось загрузить данные',
                onRetry: () => context.read<CharactersCubit>().fetchFirstPage(),
              );
            }

            final hasMore = state.pageInfo?.next != null;

            return RefreshIndicator(
              onRefresh: () => context.read<CharactersCubit>().fetchFirstPage(),
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  SizedBox(
                    height: 110,
                    child: _StoriesRow(characters: state.characters),
                  ),
                  const Divider(height: 1),
                  _CharactersList(characters: state.characters),
                  if (state.isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (hasMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: SizedBox.shrink()),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    final items = characters.isEmpty
        ? <Character>[]
        : List<Character>.generate(
            characters.length * 10,
            (index) => characters[index % characters.length],
          );
    if (items.isEmpty) {
      return const Center(child: Text('Истории появятся позже'));
    }

    final viewedIds = context.select<ViewedStoriesCubit, Set<int>>(
      (cubit) => cubit.state.viewedIds,
    );

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      primary: false,
      itemBuilder: (context, index) {
        final character = items[index];
        return StoryWidget(
          character: character,
          isViewed: viewedIds.contains(character.id),
          onTap: () => _openStoryViewer(context, items, index),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemCount: items.length,
    );
  }
}

class _CharactersList extends StatelessWidget {
  const _CharactersList({required this.characters});

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    final expandedId = context.select<ExpandedCharacterCubit, int?>(
      (cubit) => cubit.state.expandedId,
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterCard(
          character: character,
          isExpanded: expandedId == character.id,
          onTap: () =>
              context.read<ExpandedCharacterCubit>().toggle(character.id),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}

void _openModal(BuildContext context, Character character) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => CharacterModal(character: character),
  );
}

void _openStoryViewer(
  BuildContext context,
  List<Character> characters,
  int initialIndex,
) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..clearSnackBars();

  final size = MediaQuery.of(context).size;

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      duration: const Duration(days: 1),
      content: SizedBox(
        height: size.height - 24,
        width: size.width - 24,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: StoryViewerPage(
              characters: characters,
              initialIndex: initialIndex,
            ),
          ),
        ),
      ),
    ),
  );
}
