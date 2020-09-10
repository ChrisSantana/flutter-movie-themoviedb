
import 'package:fluttermovie/model/genre_model.dart';

class GenreHelper {

  List<GenreModel> _listGenre = [];

  GenreHelper(){
    _attListGenre();
  }

  List<GenreModel> getAllListGenre(){
    return _listGenre;
  }

  void _attListGenre() {
    _listGenre.add(
      GenreModel(
        id: 28,
        name: "Ação",
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 12,
        name: "Aventura",
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 16,
        name: "Animação",
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 35,
        name: "Comédia",
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 80,
        name: "Crime"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 99,
        name: "Documentário"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 18,
        name: "Drama"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 10751,
        name: "Família"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 14,
        name: "Fantasia"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 36,
        name: "História"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 27,
        name: "Terror"
      ),
    );

     _listGenre.add(
      GenreModel(
        id: 10402,
        name: "Música"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 9648,
        name: "Mistério"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 10749,
        name: "Romance"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 878,
        name: "Ficção científica"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 10770,
        name: "Cinema TV"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 53,
        name: "Thriller"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 10752,
        name: "Guerra"
      ),
    );

    _listGenre.add(
      GenreModel(
        id: 37,
        name: "Faroeste"
      ),
    );
  }

  List<GenreModel> getListGenreFromId(List<int> listId) {
    return listId.map<GenreModel>((value){
      return getGenre(value);
    }).toList();
  }

  GenreModel getGenre(int id) {
    return _listGenre.firstWhere((value){
      return value.id.compareTo(id) == 0;
    }, orElse: (){
      return GenreModel(id: 0, name: 'Desconhecido');
    });
  }

  String getTextGenre(List<int> listId) {
    if (listId == null || listId.isEmpty) return null;
    final list = getListGenreFromId(listId);
    return list != null && list.isNotEmpty ? list.map<String>((value){
      return value.name;
    })?.toList()?.join(', ') : null;
  }
}