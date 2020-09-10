import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/application_bloc.dart';
import 'package:fluttermovie/bloc/movie_tab_bloc.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/widget/geral/factory_favorite_widget.dart';
import 'package:fluttermovie/widget/geral/sliver_app_bar_widget.dart';
import 'package:provider/provider.dart';

class MovieAppBarWidget extends StatelessWidget {
  final double spaceBarHegth;
  final MovieModel movieModel;
  final MovieTabBloc movieTabBloc;

  const MovieAppBarWidget(this.spaceBarHegth, this.movieModel, this.movieTabBloc);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return StreamBuilder<bool>(
      stream: movieTabBloc.streamShowAppBar,
      builder: (context, snapshot) {
        final showAppBar = snapshot.data ?? false;
        return SliverAppBarWidget(
          expandedHeight: spaceBarHegth,
          pinned: true,
          floating: false,
          snap: false,
          brightness: !showAppBar ? Brightness.light : Brightness.dark,
          elevation: movieTabBloc.showAppBar ? null : .2,
          actions: _buildActions(bloc),
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

  List<Widget> _buildActions(ApplicationBloc bloc) {
    return [
      movieTabBloc.showAppBar
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: FactoryFavoriteWidget(movieModel.id, 21),
                onPressed: (){
                  _onPressedFavorite(bloc);
                },
              ),
            )
          : SizedBox.shrink()
    ];
  }

  void _onPressedFavorite(ApplicationBloc bloc) {
    bloc.saveFavorite(movieModel);
  }
}