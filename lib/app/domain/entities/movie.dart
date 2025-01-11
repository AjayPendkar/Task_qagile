class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String posterPath;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      posterPath: json['Poster'] ?? '',
    );
  }
} 