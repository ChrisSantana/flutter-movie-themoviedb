import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/application_bloc.dart';
import 'package:fluttermovie/bloc/movie_tab_bloc.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/widget/geral/factory_favorite_widget.dart';
import 'package:fluttermovie/widget/movie_tab/movie_app_bar_widget.dart';
import 'package:fluttermovie/widget/movie_tab/movie_genre_widget.dart';
import 'package:fluttermovie/widget/movie_tab/movie_head_widget.dart';
import 'package:provider/provider.dart';

const double SPACE_BAR_HEIGHT = 250;

class MovieTab extends StatefulWidget {
  final MovieModel movieModel;
  MovieTab(this.movieModel);
  @override
  _MovieTabState createState() => _MovieTabState(movieModel);
}

class _MovieTabState extends State<MovieTab> {
  final MovieModel movieModel;
  _MovieTabState(this.movieModel);

  double topPositionedFab;
  double _scalePositionedFab;
  double _defaultTopMargin;
  ScrollController _scrollController;

  MovieTabBloc _movieTabBloc;

  @override
  void initState() {
    super.initState();
    _initProperties();
    _scrollController = ScrollController();
    _movieTabBloc = MovieTabBloc();
    _scrollController.addListener(_handlerScrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: movieModel.urlImgPoster != null ? NetworkImage(movieModel.urlImgPoster) : AssetImage(Util.instance.imgPlaceHolder),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          CustomScrollView(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            slivers: <Widget>[
              MovieAppBarWidget(SPACE_BAR_HEIGHT, movieModel, _movieTabBloc),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    MovieHeadWidget(movieModel),
                    MovieGenreWidget(movieModel, _movieTabBloc),
                    Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Text(
                        movieModel.overview,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildFloatingActionButtonFavorito(),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtonFavorito() {
    return StreamBuilder<bool>(
      stream: _movieTabBloc.streamRebuildFab,
      builder: (context, snapshot) {
        return Positioned(
          top: topPositionedFab,
          right: 6,
          child: Transform(
            transform: Matrix4.identity()..scale(_scalePositionedFab),
            alignment: Alignment.center,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey.shade900,
              child: FactoryFavoriteWidget(movieModel.id, 21),
              onPressed: _onPressedFavorite,
            ),
          ),
        );
      },
    );
  }

  void _onPressedFavorite() {
    Provider.of<ApplicationBloc>(context, listen: false).saveFavorite(movieModel);
  }

  void _handlerScrollController() {
    _initProperties();

    ///pixels do top onde a scale deve iniciar
    final double scaleStart = 96.0;

    ///pixels do top onde a scale deve finalizar
    final double scaleEnd = scaleStart / 2;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      topPositionedFab -= offset;
      if (offset < _defaultTopMargin - scaleStart) {
        _scalePositionedFab = 1.0;
      } else if (offset < _defaultTopMargin - scaleEnd) {
        _scalePositionedFab =
            (_defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        ///esconder o FAB
        _scalePositionedFab = 0.0;
      }
    }

    if (_scrollController.offset > (SPACE_BAR_HEIGHT - (kToolbarHeight + 5))) {
      if (!_movieTabBloc.showAppBar) {
        _movieTabBloc.sinkShowAppBar(true);
      }
    } else {
      if (_movieTabBloc.showAppBar) {
        _movieTabBloc.sinkShowAppBar(false);
      }
    }

    _movieTabBloc.sinkRebuildFab(true);
  }

  void _initProperties() {
    _defaultTopMargin = SPACE_BAR_HEIGHT - 4;
    topPositionedFab = _defaultTopMargin;
    _scalePositionedFab = 1;
  }

  @override
  void dispose() {
    _movieTabBloc?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }
}
