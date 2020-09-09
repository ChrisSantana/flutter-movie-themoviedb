import 'package:fluttermovie/library/exception_helper_error.dart';
import 'package:fluttermovie/library/http_client.dart';
import 'package:fluttermovie/model/exception_model.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/model/result_model.dart';
import 'package:fluttermovie/repository/movie_service_base.dart';

import '../library/util.dart';

class MovieService implements MovieServiceBase {
  final _httpCliente = HttpClient.instance;
  final _util = Util.instance;

  static final MovieService _movie = MovieService._internal();
  static MovieService get instance { return _movie; }
  MovieService._internal();

  Future<ResultModel> getMovies(int page) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      final response = await _httpCliente.get(_util.urlMovies, page);
      if (response != null && response.data != null ) {
        return ResultModel.fromMap(response.data);
      }
      return null;
    } on ExceptionModel catch(e){
      throw e;
    } catch (e) {
      throw ExceptionHelperError.instance.handlerErroServidor();
    }
  }

  Future<List<MovieModel>> getFavorites(int page) async {
    try {
      /// TODO
      /// programar favoritos
      return null;
    } on ExceptionModel catch(e){
      throw e;
    } catch (e) {
      throw ExceptionHelperError.instance.handlerErroServidor();
    }
  }
}