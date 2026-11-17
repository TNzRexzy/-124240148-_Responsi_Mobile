import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:responsi124240148/services/game_api.dart';

void main() {
  test('fetches the FreeToGame game list endpoint', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://www.freetogame.com/api/games');
      return http.Response(
        jsonEncode([
          {
            'id': 42,
            'title': 'Example Game',
            'genre': 'Shooter',
            'platform': 'PC (Windows)',
          },
        ]),
        200,
      );
    });
    final api = GameApi(client: client);

    final games = await api.fetchGames();

    expect(games.single.title, 'Example Game');
    expect(games.single.platform, 'PC (Windows)');
    api.close();
  });

  test('fetches detail using the game id query parameter', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/game');
      expect(request.url.queryParameters['id'], '42');
      return http.Response(
        jsonEncode({
          'id': 42,
          'title': 'Example Game',
          'screenshots': [
            {'id': 1, 'image': 'https://example.com/screenshot.jpg'},
          ],
        }),
        200,
      );
    });
    final api = GameApi(client: client);

    final game = await api.fetchGame(42);

    expect(game.screenshots, ['https://example.com/screenshot.jpg']);
    api.close();
  });
}
