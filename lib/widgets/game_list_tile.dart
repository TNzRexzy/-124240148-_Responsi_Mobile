import 'package:flutter/material.dart';

import '../models/games.dart';

class GameListTile extends StatelessWidget {
  const GameListTile({
    super.key,
    required this.game,
    required this.onTap,
    this.onDelete,
  });

  final Game game;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF202020),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 88,
          child: Row(
            children: [
              _GameThumbnail(url: game.thumbnail),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        game.genre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.68),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        game.platform,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onDelete == null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
                      ),
                    )
                  : IconButton(
                      tooltip: 'Hapus dari Library',
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Color(0xFFF04438),
                      ),
                    ),
              if (onDelete != null) const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameThumbnail extends StatelessWidget {
  const _GameThumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _ThumbnailPlaceholder();
    }
    return Image.network(
      url!,
      width: 100,
      height: 88,
      fit: BoxFit.cover,
      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      errorBuilder: (_, _, _) => const _ThumbnailPlaceholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _ThumbnailPlaceholder(loading: true);
      },
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 88,
      color: const Color(0xFF303030),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(strokeWidth: 2)
          : const Icon(Icons.videogame_asset_rounded, color: Colors.white54),
    );
  }
}
