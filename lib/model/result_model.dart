import 'package:fluttermovie/model/movie_model.dart';

class ResultModel {
  final List<MovieModel> movies;
  final int page;
  final int totalResults;
  final int totalPages;

  ResultModel({
    this.movies,
    this.page,
    this.totalResults,
    this.totalPages,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
        movies: map['results'].map<MovieModel>((value){
          return MovieModel.fromMap(value);
        }).toList(),
        page: map['page'],
        totalResults: map['total_results'],
        totalPages: map['total_pages'],
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'results': movies.map((value){
        return value.toMap();
      }).toList(),
      'page': page,
      'total_results': totalResults,
      'total_pages': totalPages,
    };
  }
}