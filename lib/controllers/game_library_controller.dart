import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/games.dart';

class GameLibraryController extends GetxController {
  late final Box<Map> _box;
  final games = <Game>[].obs;

  Future<void> init() async {
    _box = await Hive.openBox<Map>('game_library');
    games.assignAll(
      _box.values.map(
        (saved) => Game.fromJson(Map<String, dynamic>.from(saved)),
      ),
    );
  }

  bool contains(int gameId) => games.any((game) => game.id == gameId);

  Future<void> toggle(Game game) async {
    if (contains(game.id)) {
      await _box.delete(game.id);
    } else {
      await _box.put(game.id, game.toJson());
    }
    games.assignAll(
      _box.values.map(
        (saved) => Game.fromJson(Map<String, dynamic>.from(saved)),
      ),
    );
  }
}
