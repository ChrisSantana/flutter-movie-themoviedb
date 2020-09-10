import 'package:fluttermovie/repository/app_service.dart';
import 'package:intl/intl.dart';

class Util {
  static final Util _util = Util._internal();
  static Util get instance { return _util; }
  Util._internal();

  /// Assets
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

  /// Base URL
  String get urlBase {
    return 'https://api.themoviedb.org/3/';
  }

  String get urlMovies {
    return '/movie/now_playing';
  }

  String get urlSearchMovies {
    return 'search/movie';
  }

  /// por questao de otimizacao e por se tratar de um teste, vou sempre obter essa resolucao para as imagens
  String get urlBaseImg {
    return 'https://image.tmdb.org/t/p/w500';
  }

  /// Textos Screen
  /// #SPLASH
  List<String> get animationSplash {
    return ['O MELHOR DO CINEMA', 'NA PALMA', 'DA SUA MÃO', 'CONFIRA OS PRINCIPAIS', 'LANÇAMENTOS', 'E OS SEUS', 'FILMES FAVORITOS'];
  }

  Future<String> get titleSplash async {
    return await AppService.instance.getAppName();
  }

  String get introSplash {
    return 'Acompanhe os principais lançamentos, veja detalhes e as principais informações dos filmes de sua preferência. Além disso, o aplicativo possibilita favoritá-los';
  }

  String get nameButtonSplash {
    return 'Tentar novamente';
  }

  /// Formatacao de numero
  String formatDouble(double value){
    final formatter = NumberFormat('#,#0.0', 'pt_BR');
    try{
      return formatter.format(value);
    } catch (e) {
      print(e);
    }
    return '0';
  }

  /// Retorna a data no formato BR
  String retornarDataPadraoBR(DateTime dateTime){
    try {
      return DateFormat.yMd('pt_BR').format(dateTime);
    } catch (e){
      print(e);
    }
    return '';
  }

  /// Retira caracteres especiais de um texto.
  /// Exemplo: flutter-framework, terá o retorno flutterframework
  String retirarCaracteresEspeciais(String text){
    if (text.trim().isEmpty) return '';

    return text.replaceAll(new RegExp(r'[^\w\s]+'),'').trim();
  }

  String normalizeQuery(String query) {
    if(query == null || query.isEmpty) return null;
    query = query.trim();
    return query.replaceAll('  ', ' ').replaceAll(' ', '+');
  }

  /// Função util para printar textos longos
  static void printWrapped(Object text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches('$text').forEach((match) => print(match.group(0)));
  }
}
