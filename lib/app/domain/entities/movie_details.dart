class MovieDetails {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final List<String> genres;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String posterUrl;
  final List<Rating> ratings;
  final String metaScore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final String boxOffice;

  MovieDetails({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genres,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.posterUrl,
    required this.ratings,
    required this.metaScore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbID,
    required this.type,
    required this.boxOffice,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    try {
      List<String> parseGenres(String genreStr) {
        try {
          return genreStr.split(',').map((e) => e.trim()).toList();
        } catch (e) {
          print('Error parsing genres: $e');
          return [];
        }
      }

      return MovieDetails(
        title: json['Title'] ?? '',
        year: json['Year'] ?? '',
        rated: json['Rated'] ?? '',
        released: json['Released'] ?? '',
        runtime: json['Runtime'] ?? '',
        genres: parseGenres(json['Genre'] ?? ''),
        director: json['Director'] ?? '',
        writer: json['Writer'] ?? '',
        actors: json['Actors'] ?? '',
        plot: json['Plot'] ?? '',
        language: json['Language'] ?? '',
        country: json['Country'] ?? '',
        awards: json['Awards'] ?? '',
        posterUrl: json['Poster'] != 'N/A' ? json['Poster'] : '',
        ratings: (json['Ratings'] as List?)
            ?.map((r) => Rating.fromJson(r as Map<String, dynamic>))
            .toList() ?? [],
        metaScore: json['Metascore'] ?? '',
        imdbRating: json['imdbRating'] ?? '',
        imdbVotes: json['imdbVotes'] ?? '',
        imdbID: json['imdbID'] ?? '',
        type: json['Type'] ?? '',
        boxOffice: json['BoxOffice'] ?? '',
      );
    } catch (e) {
      print('Error parsing MovieDetails: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  factory MovieDetails.empty() => MovieDetails(
    title: '',
    year: '',
    rated: '',
    released: '',
    runtime: '',
    genres: [],
    director: '',
    writer: '',
    actors: '',
    plot: '',
    language: '',
    country: '',
    awards: '',
    posterUrl: '',
    ratings: [],
    metaScore: '',
    imdbRating: '0',
    imdbVotes: '',
    imdbID: '',
    type: '',
    boxOffice: '',
  );
}

class Rating {
  final String source;
  final String value;

  Rating({
    required this.source,
    required this.value,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      source: json['Source'] ?? '',
      value: json['Value'] ?? '',
    );
  }
} 