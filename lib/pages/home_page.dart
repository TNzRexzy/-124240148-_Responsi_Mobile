import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/games.dart';
import '../services/game_api.dart';
import '../widgets/game_list_tile.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GamesController _controller;
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedGenre = 'Semua';

  @override
  void initState() {
    super.initState();
    _controller = Get.put(GamesController(GameApi()));
    _controller.loadGames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    Get.delete<GamesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (_controller.isLoading.value && _controller.games.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.error.value.isNotEmpty && _controller.games.isEmpty) {
          return _ErrorState(
            message: _controller.error.value,
            onRetry: _controller.loadGames,
          );
        }

        final allGames = _controller.games;
        final genres = [
          'Semua',
          ...allGames.map((game) => game.genre).toSet().toList()..sort(),
        ];
        if (!genres.contains(_selectedGenre)) _selectedGenre = 'Semua';
        final games = allGames.where((game) {
          final matchesText = game.title.toLowerCase().contains(
            _query.toLowerCase(),
          );
          final matchesGenre =
              _selectedGenre == 'Semua' || game.genre == _selectedGenre;
          return matchesText && matchesGenre;
        }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Browse Games',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.sports_esports_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Cari game...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        return ChoiceChip(
                          label: Text(genre),
                          selected: _selectedGenre == genre,
                          showCheckmark: false,
                          onSelected: (_) =>
                              setState(() => _selectedGenre = genre),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${games.length} game',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_controller.isLoading.value)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: games.isEmpty
                  ? const Center(child: Text('Game tidak ditemukan.'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                      itemCount: games.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return GameListTile(
                          game: game,
                          onTap: () =>
                              Get.to(() => DetailPage(gameId: game.id)),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class GamesController extends GetxController {
  GamesController(this._api);

  final GameApi _api;
  final games = <Game>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> loadGames() async {
    isLoading.value = true;
    error.value = '';
    try {
      games.assignAll(await _api.fetchGames());
    } on Exception catch (exception) {
      error.value =
          'Gagal memuat game. Periksa koneksi internet lalu coba lagi.\n$exception';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _api.close();
    super.onClose();
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
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 44),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
