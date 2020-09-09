import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/model/result_model.dart';

abstract class MovieServiceBase {
  Future<ResultModel> getMovies(int page);

  Future<List<MovieModel>> getFavorites(int page);
}