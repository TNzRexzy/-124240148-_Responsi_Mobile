import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_library_controller.dart';
import '../models/games.dart';
import '../services/game_api.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.gameId});

  final int gameId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final GameApi _api;
  late Future<Game> _gameFuture;

  @override
  void initState() {
    super.initState();
    _api = GameApi();
    _gameFuture = _api.fetchGame(widget.gameId);
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  void _retry() {
    setState(() => _gameFuture = _api.fetchGame(widget.gameId));
  }

  String _plainText(String text) => text
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: FutureBuilder<Game>(
        future: _gameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 42),
                    const SizedBox(height: 14),
                    const Text(
                      'Detail game tidak berhasil dimuat.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba lagi'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
              ),
            );
          }

          final game = snapshot.data!;
          final library = Get.find<GameLibraryController>();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: game.thumbnail == null
                      ? const _ImagePlaceholder()
                      : Image.network(
                          game.thumbnail!,
                          fit: BoxFit.cover,
                          webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const _ImagePlaceholder(loading: true);
                          },
                          errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(game.genre),
                          _InfoChip(game.platform),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        game.title,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _MetaInfo(
                            label: 'Release Date',
                            value: _formatDate(game.releaseDate),
                          ),
                          _MetaInfo(label: 'Publisher', value: game.publisher),
                          _MetaInfo(label: 'Developer', value: game.developer),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Obx(() {
                        final isOwned = library.contains(game.id);
                        return SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: FilledButton.icon(
                            onPressed: isOwned
                                ? null
                                : () => library.toggle(game),
                            icon: Icon(
                              isOwned ? Icons.check_rounded : Icons.add_rounded,
                            ),
                            label: Text(isOwned ? 'In Library' : 'Get'),
                            style: FilledButton.styleFrom(
                              backgroundColor: isOwned
                                  ? Colors.white38
                                  : const Color(0xFF4285F4),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.white38,
                              disabledForegroundColor: Colors.white,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 22),
                      const Text(
                        'Screenshots',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (game.screenshots.isEmpty)
                        Text(
                          'Screenshot belum tersedia.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        )
                      else
                        SizedBox(
                          height: 112,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: game.screenshots.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                game.screenshots[index],
                                width: 180,
                                height: 112,
                                fit: BoxFit.cover,
                                webHtmlElementStrategy:
                                    WebHtmlElementStrategy.prefer,
                                errorBuilder: (_, _, _) =>
                                    const _ImagePlaceholder(),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 22),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.description.isEmpty
                            ? 'Deskripsi game belum tersedia.'
                            : _plainText(game.description),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          height: 1.55,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Unknown';
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  const _MetaInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF26272D),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(strokeWidth: 2)
          : const Icon(
              Icons.videogame_asset_rounded,
              size: 50,
              color: Colors.white38,
            ),
    );
  }
}
