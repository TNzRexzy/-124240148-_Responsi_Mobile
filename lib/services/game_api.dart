import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/games.dart';

class GameApi {
  GameApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://www.freetogame.com/api';

  Future<List<Game>> fetchGames() async {
    final response = await _client.get(Uri.parse('$_baseUrl/games'));
    if (response.statusCode != 200) {
      throw Exception(
        'Hydra Games gagal memuat daftar game (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Game.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Game> fetchGame(int id) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/game').replace(queryParameters: {'id': '$id'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Hydra Games gagal memuat detail game (${response.statusCode}).',
      );
    }

    return Game.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void close() => _client.close();
}
