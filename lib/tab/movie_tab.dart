import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/movie_tab_bloc.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/widget/geral/sliver_app_bar_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              _buildAppBar(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildHeadContent(),
                    _buildGenre(),
                    _buildContent(),
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

  Widget _buildHeadContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _buildFadeImage(movieModel.urlImgPoster, BoxFit.cover),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildInformation('Título original: ${movieModel.originalTitle}', 0),
                  _buildInformation('Lançamento: ${Util.instance.retornarDataPadraoBR(movieModel.releaseDate)}'),
                  _buildInformation('Popularidade: ${Util.instance.formatDouble(movieModel.popularity)}'),
                  _buildInformation('Avaliação: ${Util.instance.formatDouble(movieModel.voteAverage)}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Text(
        movieModel.overview,
        style: TextStyle(
          fontSize: 16,
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildInformation(String text, [double paddingTop = 6]) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Text(
        text, 
        maxLines: 3,
        style: TextStyle(
          fontSize: 15.5,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildGenre() {
    final text = _movieTabBloc.getTextGenre(movieModel.genreIds);
    if (text != null && text.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          borderRadius: BorderRadius.circular(6)
        ),
        child: Text(
          'Gênero: $text',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.5),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildAppBar() {
    return StreamBuilder<bool>(
      stream: _movieTabBloc.streamShowAppBar,
      builder: (context, snapshot) {
        final showAppBar = snapshot.data ?? false;
        return SliverAppBarWidget(
          expandedHeight: SPACE_BAR_HEIGHT,
          pinned: true,
          floating: false,
          snap: false,
          brightness: !showAppBar ? Brightness.light : Brightness.dark,
          elevation: _movieTabBloc.showAppBar ? null : .2,
          actions: _buildActions(),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            title: Text(
              movieModel.title,
              style: TextStyle(
                shadows: [
                  BoxShadow(
                    color: Colors.black87,
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            background: _buildFadeImage(movieModel.urlImBackdrop, BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildFadeImage(String urlImg, BoxFit boxFit) {
    return FadeInImage(
      image: urlImg != null ? NetworkImage(urlImg) : AssetImage(Util.instance.imgPlaceHolder),
      placeholder: AssetImage(Util.instance.imgPlaceHolder),
      fit: boxFit,
    );
  }

  List<Widget> _buildActions() {
    return [
      _movieTabBloc.showAppBar
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.heart,
                  size: 21,
                ),
                onPressed: () {},
              ),
            )
          : SizedBox.shrink()
    ];
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
              backgroundColor: Colors.white,
              child: Icon(
                FontAwesomeIcons.heart,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
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
