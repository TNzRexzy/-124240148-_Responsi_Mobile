import 'package:flutter_test/flutter_test.dart';
import 'package:responsi124240148/models/games.dart';

void main() {
  test('parses and stores FreeToGame game fields', () {
    final game = Game.fromJson({
      'id': 42,
      'title': 'Example Game',
      'thumbnail': 'https://example.com/thumb.jpg',
      'genre': 'Shooter',
      'platform': 'PC (Windows)',
      'release_date': '2024-01-02',
      'publisher': 'Example Publisher',
      'developer': 'Example Developer',
      'short_description': 'A short description',
      'description': 'A detailed description',
      'game_url': 'https://example.com/game',
      'screenshots': [
        {'id': 1, 'image': 'https://example.com/screenshot.jpg'},
      ],
    });

    final saved = Game.fromJson(game.toJson());
    expect(saved.title, 'Example Game');
    expect(saved.thumbnail, 'https://example.com/thumb.jpg');
    expect(saved.genre, 'Shooter');
    expect(saved.platform, 'PC (Windows)');
    expect(saved.releaseDate, DateTime(2024, 1, 2));
    expect(saved.publisher, 'Example Publisher');
    expect(saved.developer, 'Example Developer');
    expect(saved.description, 'A detailed description');
    expect(saved.screenshots, ['https://example.com/screenshot.jpg']);
  });

  test('uses the short description when detail description is missing', () {
    final game = Game.fromJson({
      'id': 7,
      'title': 'Example Game',
      'short_description': 'Fallback description',
    });

    expect(game.description, 'Fallback description');
  });
}
