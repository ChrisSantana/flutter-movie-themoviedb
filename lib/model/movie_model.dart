import 'package:fluttermovie/library/util.dart';
import 'package:path/path.dart';

class MovieModel {
  final int id;
  final double popularity;
  final bool video;
  final int voteCount;
  final double voteAverage;
  final String title;
  final DateTime releaseDate;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String posterPath;

  MovieModel({
    this.popularity,
    this.id,
    this.video,
    this.voteCount,
    this.voteAverage,
    this.title,
    this.releaseDate,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.posterPath,
  });

  String get urlImgPoster {
    if (posterPath != null && posterPath.isNotEmpty) {
      return join(Util.instance.urlBaseImg, posterPath.replaceAll('/', ''));
    }
    return null;
  }

  String get urlImBackdrop {
    if (backdropPath != null && backdropPath.isNotEmpty) {
      return join(Util.instance.urlBaseImg, backdropPath.replaceAll('/', ''));
    }
    return null;
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      popularity: map['popularity']?.toDouble(),
      id: map['id'],
      video: map['video'],
      voteCount: map['vote_count'],
      voteAverage: map['vote_average']?.toDouble(),
      title: map['title'],
      releaseDate: map['release_date'] != null && map['release_date'].isNotEmpty ? DateTime.parse(map['release_date']) : null,
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      genreIds: map['genre_ids'] != null && map['genre_ids'].isNotEmpty ? List<int>.from(map['genre_ids'].map((value) { return value;})) : null,
      backdropPath: map['backdrop_path'],
      adult: map['adult'],
      overview: map['overview'],
      posterPath: map['poster_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'popularity': popularity,
      'id': id,
      'video': video,
      'vote_count': voteCount,
      'vote_average': voteAverage,
      'title': title,
      'release_date': releaseDate?.toIso8601String(),
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'genre_ids': genreIds != null && genreIds.isNotEmpty ? List<int>.from(genreIds.map<int>((value) { return value; })) : null,
      'backdrop_path': backdropPath,
      'adult': adult,
      'overview': overview,
      'poster_path': posterPath,
    };
  }
}