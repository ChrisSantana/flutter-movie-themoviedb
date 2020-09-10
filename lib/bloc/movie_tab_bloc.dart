import 'package:fluttermovie/bloc/bloc.dart';
import 'package:fluttermovie/library/genre_helper.dart';
import 'package:rxdart/rxdart.dart';

class MovieTabBloc implements Bloc {

  bool _showAppBar = false;
  bool get showAppBar { return _showAppBar; }

  BehaviorSubject<bool> _controllerShowAppBar;
  Function(bool) get sinkShowAppBar { return _controllerShowAppBar.sink.add; }
  Stream<bool> get streamShowAppBar { return _controllerShowAppBar.stream; }

  BehaviorSubject<bool> _controllerRebuildFab;
  Function(bool) get sinkRebuildFab { return _controllerRebuildFab.sink.add; }
  Stream<bool> get streamRebuildFab { return _controllerRebuildFab.stream; }

  MovieTabBloc() {
    _controllerShowAppBar = BehaviorSubject<bool>.seeded(false);
    _controllerRebuildFab = BehaviorSubject<bool>.seeded(false);
    _controllerShowAppBar.listen(_handlerShowAppBar);
  }

  String getTextGenre(List<int> listId) {
    return GenreHelper().getTextGenre(listId);
  }

  void _handlerShowAppBar(bool value) {
    _showAppBar = value;
  }

  @override
  void dispose() async {
    await _controllerShowAppBar?.close();
    await _controllerRebuildFab?.close();
  }
}