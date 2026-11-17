class Game {
  const Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.releaseDate,
    required this.publisher,
    required this.developer,
    required this.description,
    required this.screenshots,
    this.gameUrl,
  });

  final int id;
  final String title;
  final String? thumbnail;
  final String genre;
  final String platform;
  final DateTime? releaseDate;
  final String publisher;
  final String developer;
  final String description;
  final List<String> screenshots;
  final String? gameUrl;

  factory Game.fromJson(Map<String, dynamic> json) {
    final screenshotData = json['screenshots'];
    final screenshots = screenshotData is List
        ? screenshotData
              .map((item) {
                if (item is String) return item;
                if (item is Map) return item['image'];
                return null;
              })
              .whereType<String>()
              .where((url) => url.isNotEmpty)
              .toList()
        : <String>[];
    final rawDate = json['release_date'];

    return Game(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'Untitled game',
      thumbnail: json['thumbnail'] as String?,
      genre: json['genre'] as String? ?? 'Unknown',
      platform: json['platform'] as String? ?? 'Unknown',
      releaseDate: rawDate is String ? DateTime.tryParse(rawDate) : null,
      publisher: json['publisher'] as String? ?? 'Unknown',
      developer: json['developer'] as String? ?? 'Unknown',
      description:
          json['description'] as String? ??
          json['short_description'] as String? ??
          '',
      screenshots: screenshots,
      gameUrl: json['game_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'thumbnail': thumbnail,
    'genre': genre,
    'platform': platform,
    'release_date': releaseDate?.toIso8601String(),
    'publisher': publisher,
    'developer': developer,
    'description': description,
    'screenshots': screenshots,
    'game_url': gameUrl,
  };
}
