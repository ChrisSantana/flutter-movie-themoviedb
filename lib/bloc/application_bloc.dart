import 'package:flutter/material.dart';
import 'package:fluttermovie/enum/enum_screen.dart';
import 'package:fluttermovie/model/exception_model.dart';
import 'package:fluttermovie/model/screen_model.dart';
import 'package:fluttermovie/repository/app_service.dart';
import 'package:fluttermovie/repository/movie_service.dart';
import 'package:fluttermovie/screen/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../enum/enum_app_retorno.dart';
import '../enum/enum_theme.dart';
import '../library/shared_preferences_helper.dart';
import '../library/theme_helper.dart';
import '../bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../model/app_retorno_model.dart';

const _keyTheme = 'key_thema_user';

class ApplicationBloc implements Bloc {
  PageController get pageController { return _pageController; }
  PageController _pageController;

  BehaviorSubject<AppRetornoModel> _controllerRetornoAPI;
  Function(AppRetornoModel) get _changeAppRetorno { return _controllerRetornoAPI.add; }
  Stream<AppRetornoModel> get streamRetornoAPI { return _controllerRetornoAPI.stream; }

  BehaviorSubject<int> _controllerBottomNavigatorBar;
  Function(int) get sinkBottomNavigatorBar { return _controllerBottomNavigatorBar.sink.add; }
  Stream<int> get streamBottomNavigatorBar { return _controllerBottomNavigatorBar.stream; }

  BehaviorSubject<int> _controllerTheme;
  Function(int) get _sinkTheme { return _controllerTheme.sink.add; }
  Stream<int> get streamTheme { return _controllerTheme.stream; }

  ApplicationBloc() {
    _controllerRetornoAPI = BehaviorSubject<AppRetornoModel>();
    _controllerBottomNavigatorBar = BehaviorSubject<int>();
    _controllerTheme = BehaviorSubject<int>.seeded(ThemeEnum.escuro.index);

    _pageController = PageController(initialPage: getListaScreenModel().first.position.index);
    _controllerBottomNavigatorBar.listen(_handlerNavigatorBar);
    _loadTheme().then(attTheme);

    init();
  }

  void init() async {
    try {
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.processando, data: _controllerRetornoAPI?.value?.data));

      final retorno = await MovieService.instance.getMovies(1);
      final sucesso = retorno != null && retorno.movies != null && retorno.movies.isNotEmpty;
      
      _changeAppRetorno(AppRetornoModel(state: sucesso ? AppRetornoEnum.concluido : AppRetornoEnum.erro, data: retorno));
      
      if (sucesso){
        AppService.instance.navigatePushReplecementTo(HomeScreen(), animated: true);
      }
    } on ExceptionModel catch (e) {
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.erro, data: e.msg));
    } catch (_) {
      _changeAppRetorno(AppRetornoModel(state: AppRetornoEnum.erro, data: 'Erro de requisição'));
    }
  }

  void _handlerNavigatorBar(int value) {
    if (value != null) {
      _pageController?.jumpToPage(value);
    }
  }

  ThemeData getThemeData(int codTheme) {
    try {
      if (codTheme != null && codTheme == ThemeEnum.escuro.index){
        return ThemeHelper.instance.dark;
      }
    } catch(e){}
    return ThemeHelper.instance.classic;
  }

  void attTheme(int codTheme){
    if (codTheme != null){
      _sinkTheme(codTheme);
    }
  }

  Future<int> _loadTheme() async {
    try {
      final str = await SharedPreferencesHelper.instance.loadData(_keyTheme);
      if (str != null && str.isNotEmpty) {
        return int.parse(str);
      }
    } catch(e){}
    return null;
  }

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
    await _controllerTheme?.close();
    await _controllerRetornoAPI?.close();
    _pageController?.dispose();
  }
}