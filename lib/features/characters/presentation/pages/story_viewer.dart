import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/presentation/pages/story_playback_controller.dart';
import 'package:randm_concept/features/characters/presentation/blocs/viewed_stories_cubit.dart';

class StoryViewerPage extends StatefulWidget {
  const StoryViewerPage({
    super.key,
    required this.characters,
    required this.initialIndex,
  });

  final List<Character> characters;
  final int initialIndex;

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with TickerProviderStateMixin {
  late final PageController _controller;
  late final StoryPlaybackController _playback;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
    _playback = StoryPlaybackController(
      vsync: this,
      duration: const Duration(seconds: 4),
      onCompleted: _handleCompleted,
    );
    _playback.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context
          .read<ViewedStoriesCubit>()
          .markViewed(widget.characters[_currentIndex].id);
    });
  }

  @override
  void dispose() {
    _playback.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleCompleted() {
    if (!mounted) {
      return;
    }

    _goToIndex(_currentIndex + 1);
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    context
        .read<ViewedStoriesCubit>()
        .markViewed(widget.characters[index].id);
    _playback
      ..reset()
      ..start();
  }

  void _goToIndex(int index) {
    if (!mounted) {
      return;
    }

    if (index < 0) {
      return;
    }

    if (index >= widget.characters.length) {
      _closeViewer();
      return;
    }

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  void _closeViewer() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              onPageChanged: _handlePageChanged,
              itemCount: widget.characters.length,
              itemBuilder: (context, index) {
                final character = widget.characters[index];
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CachedNetworkImage(
                        imageUrl: character.image,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      character.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Статус', value: character.status),
                    _InfoRow(label: 'Вид', value: character.species),
                    _InfoRow(label: 'Пол', value: character.gender),
                    _InfoRow(label: 'Origin', value: character.origin.name),
                    _InfoRow(label: 'Location', value: character.location.name),
                    _InfoRow(
                      label: 'Эпизоды',
                      value: '${character.episode.length}',
                    ),
                  ],
                );
              },
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPressStart: (_) => _playback.pause(),
                onLongPressEnd: (_) => _playback.resume(),
                onTapUp: (details) {
                  final width = MediaQuery.of(context).size.width;
                  final isLeft = details.localPosition.dx < width / 2;
                  _playback
                    ..reset()
                    ..start();
                  _goToIndex(_currentIndex + (isLeft ? -1 : 1));
                },
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              top: 8,
              child: _StoryProgressBar(
                itemCount: widget.characters.length,
                currentIndex: _currentIndex,
                animation: _playback.animation,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _closeViewer,
                tooltip: 'Закрыть',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar({
    required this.itemCount,
    required this.currentIndex,
    required this.animation,
  });

  final int itemCount;
  final int currentIndex;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Row(
          children: List.generate(itemCount, (index) {
            final value = index < currentIndex
                ? 1.0
                : index == currentIndex
                    ? animation.value
                    : 0.0;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 4,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
