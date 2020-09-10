import 'dart:convert';

import 'package:fluttermovie/library/exception_helper_error.dart';
import 'package:fluttermovie/library/shared_preferences_helper.dart';
import 'package:fluttermovie/repository/http_client.dart';
import 'package:fluttermovie/model/exception_model.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/model/result_model.dart';
import 'package:fluttermovie/repository/movie_service_base.dart';

import '../library/util.dart';

const _KEY_FAVORITE = 'key_favorite';

class MovieService implements MovieServiceBase {
  final _httpCliente = HttpClient.instance;
  final _util = Util.instance;

  static final MovieService _movie = MovieService._internal();
  static MovieService get instance { return _movie; }
  MovieService._internal();

  Future<ResultModel> getMovies(int page, String query) async {
    try { 
      final url = query == null || query.trim().isEmpty ? _util.urlMovies : _util.urlSearchMovies;
      final response = await _httpCliente.get(url, page, query);
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

  Future<List<MovieModel>> getFavorites() async {
    try {
      final jsonStr = await _loadFavorites();
      if (jsonStr != null && jsonStr.isNotEmpty){
        final jsonMap = jsonDecode(jsonStr);
        return jsonMap.map<MovieModel>((value){
          return MovieModel.fromMap(value);
        }).toList();
      }
    } on ExceptionModel catch(e){
      throw e;
    } catch (e) {
      throw ExceptionHelperError.instance.handlerErroServidor();
    }
    return null;
  }

  Future<bool> saveOrDeleteFavorite(MovieModel model) async {
    if(model == null || model.id == null) return null;
    try {
      final list = (await getFavorites()) ?? List<MovieModel>();
      if (_contains(model.id, list)){
        list.removeWhere((value){
          return value.id.compareTo(model.id) == 0;
        });
      } else {
        list.add(model);
      }
      return await _saveFavorites(list);
    } on ExceptionModel catch(e){
      throw e;
    } catch (e) {
      throw ExceptionHelperError.instance.handlerErroServidor();
    }
  }

  Future<String> _loadFavorites() async {
    try {
      return await SharedPreferencesHelper.instance.loadData(_KEY_FAVORITE);
    } catch(e){}
    return null;
  }

  Future<bool> _saveFavorites(List<MovieModel> list) async {
    try {
      if (list != null && list.isNotEmpty){
        final listMap = list.map((value){
          return value.toMap();
        }).toList();
        return await SharedPreferencesHelper.instance.saveData(_KEY_FAVORITE, jsonEncode(listMap));
      } else {
        return await _deleteFavorites();
      }
    } catch(e){}
    return null;
  }

  Future<bool> _deleteFavorites() async {
    try {
      return await SharedPreferencesHelper.instance.deleteData(_KEY_FAVORITE);
    } catch(e){}
    return null;
  }

  bool _contains(int id, List<MovieModel> list) {
    return list.firstWhere((value){
      return value.id.compareTo(id) == 0;
    }, orElse: () { return null; }) != null;
  }

  Future<bool> isFavoriteMovie(int idMovie) async {
    final list = await getFavorites();
    if(list == null || list.isEmpty) return false;
    return list.firstWhere((value){
      return value.id.compareTo(idMovie) == 0;
    }, orElse: () { return null; }) != null;
  }
}