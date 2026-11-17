import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_library_controller.dart';
import '../widgets/game_list_tile.dart';
import 'detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final library = Get.find<GameLibraryController>();
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 18),
            child: Text(
              'Library Anda',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (library.games.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada game di Library.\nTambahkan game dari halaman Detail.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.62),
                      height: 1.5,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                itemCount: library.games.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final game = library.games[index];
                  return GameListTile(
                    game: game,
                    onTap: () => Get.to(() => DetailPage(gameId: game.id)),
                    onDelete: () => library.toggle(game),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
