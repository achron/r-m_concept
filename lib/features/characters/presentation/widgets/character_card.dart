import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';
import 'package:randm_concept/features/characters/presentation/blocs/likes_cubit.dart';
import 'package:randm_concept/features/characters/presentation/widgets/character_expanded.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.isExpanded,
  });

  final Character character;
  final VoidCallback onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final liked = context.select<LikesCubit, bool>(
      (cubit) => cubit.state.likedIds.contains(character.id),
    );

    final theme = Theme.of(context);
    final cardRadius = (theme.cardTheme.shape as RoundedRectangleBorder?)
            ?.borderRadius
            .resolve(Directionality.of(context)) ??
        BorderRadius.circular(20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: theme.cardTheme.color,
        elevation: theme.cardTheme.elevation ?? 0,
        shadowColor: theme.cardTheme.shadowColor,
        borderRadius: cardRadius,
        child: InkWell(
          borderRadius: cardRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  character.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<LikesCubit>()
                                    .toggleLike(character.id),
                                icon: Icon(
                                  liked ? Icons.favorite : Icons.favorite_border,
                                  color: liked
                                      ? Colors.redAccent
                                      : theme.colorScheme.secondary,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            character.species,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            character.status,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                        _CharacterImage(
                          imageUrl: character.image,
                          isExpanded: isExpanded,
                        ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: CharacterExpanded(character: character),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 280),
                  sizeCurve: Curves.easeInOut,
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  const _CharacterImage({required this.imageUrl, required this.isExpanded});

  final String imageUrl;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final size = isExpanded ? 96.0 : 72.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
