import 'package:flutter/material.dart';
import 'package:fluttermovie/enum/enum_screen.dart';
import 'package:fluttermovie/library/debounce_helper.dart';
import 'package:fluttermovie/library/exception_helper_error.dart';
import 'package:fluttermovie/model/exception_model.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/model/result_model.dart';
import 'package:fluttermovie/model/screen_model.dart';
import 'package:fluttermovie/repository/app_service.dart';
import 'package:fluttermovie/repository/movie_service.dart';
import 'package:fluttermovie/screen/home_screen.dart';
import 'package:fluttermovie/widget/geral/show_dialog_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enum/enum_app_retorno.dart';
import '../bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../model/app_retorno_model.dart';

class ApplicationBloc implements Bloc {

  /// BehaviorSubject
  BehaviorSubject<AppRetornoModel> _controllerRetornoAPI;
  Function(AppRetornoModel) get _changeAppRetorno { return _controllerRetornoAPI.add; }
  Stream<AppRetornoModel> get streamRetornoAPI { return _controllerRetornoAPI.stream; }

  BehaviorSubject<int> _controllerBottomNavigatorBar;
  Function(int) get sinkBottomNavigatorBar { return _controllerBottomNavigatorBar.sink.add; }
  Stream<int> get streamBottomNavigatorBar { return _controllerBottomNavigatorBar.stream; }

  BehaviorSubject<bool> _controllerHabilitarBtnAnterior;
  Function(bool) get _changeHabilitarBtnAnterior { return _controllerHabilitarBtnAnterior.add; }
  Stream<bool> get streamHabilitarBtnAnterior { return _controllerHabilitarBtnAnterior.stream; }

  BehaviorSubject<bool> _controllerHabilitarBtnProximo;
  Function(bool) get _changeHabilitarBtnProximo { return _controllerHabilitarBtnProximo.add; }
  Stream<bool> get streamHabilitarBtnProximo { return _controllerHabilitarBtnProximo.stream; }

  BehaviorSubject<String> _controllerPageFrom;
  Function(String) get sinkBottomPageFrom { return _controllerPageFrom.sink.add; }
  Stream<String> get streamPageFrom { return _controllerPageFrom.stream; }

  BehaviorSubject<bool> _controllerAttFavorite;
  Function(bool) get _changeAttFavorite { return _controllerAttFavorite.add; }
  Stream<bool> get streamAttFavorite { return _controllerAttFavorite.stream; }

  ApplicationBloc() {
    _controllerRetornoAPI = BehaviorSubject<AppRetornoModel>.seeded(AppRetornoModel(state: AppRetornoEnum.processando, data: null));
    _controllerBottomNavigatorBar = BehaviorSubject<int>();
    _controllerHabilitarBtnAnterior = BehaviorSubject<bool>.seeded(false);
    _controllerHabilitarBtnProximo = BehaviorSubject<bool>.seeded(true);
    _controllerPageFrom = BehaviorSubject<String>.seeded('');
    _controllerAttFavorite = BehaviorSubject<bool>();

    _pageController = PageController(initialPage: getListaScreenModel().first.position.index);
    _controllerBottomNavigatorBar.listen(_handlerNavigatorBar);
    _controllerRetornoAPI.listen(_handlerRetornoAPI);

    _handlerInitApp();
  }

  /// Variaveis
  String _query;

  PageController get pageController { return _pageController; }
  PageController _pageController;

  List<MovieModel> get listMovie {
    final value = _controllerRetornoAPI.value?.data;
    return value != null && value is ResultModel ? value.movies : [];
  }

  String get getPageFrom {
    final value = _controllerRetornoAPI.value?.data;
    if (value != null && value is ResultModel && value.movies != null && value.movies.isNotEmpty){
      final totalPage = value.totalPages ?? 0;
      final page = value.page ?? 0;
      return '$page / $totalPage';
    }
    return '';
  }

  int get getPage {
    if (_isValidate()) {
      final value = _controllerRetornoAPI.value?.data;
      return value?.page ?? 0;
    }
    return 0;
  }

  int get getTotalPage {
    final value = _controllerRetornoAPI.value?.data;
    if (value != null && value is ResultModel){
      return  value?.totalPages ?? 0;
    }
    return 0;
  }

  /// Requisicao a API
  Future<bool> requestAPI([int page = 1]) async {
    try {
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.processando, data: _controllerRetornoAPI?.value?.data));

      final retorno = await MovieService.instance.getMovies(page > 0 ? page : 1, _query);
      final sucesso = retorno != null && retorno.movies != null && retorno.movies.isNotEmpty;
      
      _changeAppRetorno(AppRetornoModel(state: sucesso ? AppRetornoEnum.concluido : AppRetornoEnum.erro, data: retorno));
      return sucesso;
    } on ExceptionModel catch (e) {
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.erro, data: e.msg));
      showToast(e.msg);
    } catch (_) {
      final msg = ExceptionHelperError.instance.handlerErroConexao().msg;
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.erro, data: msg));
      showToast(msg);
    }
    return false;
  }

  /// Handler
  void _handlerRetornoAPI(AppRetornoModel model) {
    if (model != null && model.state != null) {
      switch (model.state) {
        case AppRetornoEnum.processando:
          _changeHabilitarBtnAnterior(false);
          _changeHabilitarBtnProximo(false);
          break;
        default:
          _changeHabilitarBtnAnterior(getPage != null && getPage > 1);
          _changeHabilitarBtnProximo(getPage != null && getTotalPage != null && getPage < getTotalPage);
      }
      sinkBottomPageFrom(getPageFrom);
    }
  }

  void _handlerInitApp() async {
    Future.delayed(Duration(seconds: 4), () async {
      final sucesso = await requestAPI();
      if (sucesso){
        AppService.instance.navigatePushReplecementTo(HomeScreen(), animated: true);
      }
    });
  }

  void handlerPesquisa(String query) {
    DebouncerHelper.run(() {
      _query = query;
      requestAPI(getPage);
    });
  }

  void _handlerNavigatorBar(int value) {
    if (value != null) {
      _pageController?.jumpToPage(value);
    }
  }

  void onPressedAnterior() {
    requestAPI(getPage != null ? (getPage - 1) : 1);
  }

  void onPressedProximo() {
    requestAPI(getPage != null ? (getPage + 1) : 1);
  }

  bool _isValidate() {
    final value = _controllerRetornoAPI.value?.data;
    return value != null && value is ResultModel;
  }

  /// Favoritos
  Future<bool> isFavoriteMovie(int idMovie) async {
    return await MovieService.instance.isFavoriteMovie(idMovie);
  }

  void saveFavorite(MovieModel model) async {
    MovieService.instance.saveOrDeleteFavorite(model).then((value){
      _changeAttFavorite(true);
    });
  }

  /// Thema
  ThemeData getThemeData() {
    return ThemeData.dark();
  }

  /// Screen
  List<ScreenModel> getListaScreenModel() {
    return [
      ScreenModel(ScreenEnum.movie, 'Filmes', FontAwesomeIcons.film),
      ScreenModel(ScreenEnum.favorito, 'Favoritos', FontAwesomeIcons.solidHeart),
    ];
  }

  ScreenModel getScreenModel(ScreenEnum screenEnum) {
    return getListaScreenModel().firstWhere((value){
      return value.position.index.compareTo(screenEnum.index) == 0;
    }, orElse: () { return null; });
  }

  @override
  void dispose() async {
    await _controllerBottomNavigatorBar?.close();
    await _controllerRetornoAPI?.close();
    await _controllerHabilitarBtnAnterior?.close();
    await _controllerHabilitarBtnProximo?.close();
    await _controllerPageFrom?.close();
    await _controllerAttFavorite?.close();
    _pageController?.dispose();
  }
}