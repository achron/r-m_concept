import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randm_concept/features/characters/domain/models/character.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.character,
    required this.isViewed,
    this.onTap,
  });

  final Character character;
  final bool isViewed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StoryAvatar(imageUrl: character.image, isViewed: isViewed),
            const SizedBox(height: 6),
            Text(
              character.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  const _StoryAvatar({required this.imageUrl, required this.isViewed});

  final String imageUrl;
  final bool isViewed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isViewed
        ? theme.colorScheme.outline.withOpacity(0.45)
        : Colors.green.shade400;

    return CircleAvatar(
      radius: 28,
      backgroundColor: color,
      child: CircleAvatar(
        radius: 26,
        backgroundImage: CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}
