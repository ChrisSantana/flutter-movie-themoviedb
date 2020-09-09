import 'package:intl/intl.dart';

class Util {
  static final Util _util = Util._internal();
  static Util get instance { return _util; }
  Util._internal();

  String get imgNotFound  { 
    return 'assets/img/img-not-found.png'; 
  }

  String get imgPlaceHolder {
    return 'assets/img/placeholder.png'; 
  }

  String get imgBackgroundSplash {
    return 'assets/img/background-splash.jpg';
  }

  String get assetsKey {
    return 'assets/source/key.txt';
  }

  String get urlBase {
    return 'https://api.themoviedb.org/3/';
  }

  String get urlMovies {
    return '/movie/now_playing';
  }

  /// por questao de otimizacao e por se tratar de um teste, vou sempre obter essa resolucao para as imagens
  String get urlBaseImg {
    return 'https://image.tmdb.org/t/p/w500/';
  }

  /// Retorna a data no formato BR.
  String retornarDataPadraoBR(DateTime dateTime){
    try {
      return DateFormat.yMd('pt_BR').format(dateTime);
    } catch (e){
      print(e);
    }
    return '';
  }

  /// Função util para printar textos longos
  static void printWrapped(Object text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches('$text').forEach((match) => print(match.group(0)));
  }
}
