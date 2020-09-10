import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/application_bloc.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/repository/app_service.dart';
import 'package:fluttermovie/tab/movie_tab.dart';
import 'package:fluttermovie/widget/geral/factory_favorite_widget.dart';
import 'package:provider/provider.dart';

class MovieTile extends StatelessWidget {
  final MovieModel movieModel;

  const MovieTile(this.movieModel) : assert(movieModel != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        height: MediaQuery.of(context).size.height * .28,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: movieModel.urlImBackdrop != null ? NetworkImage(movieModel.urlImBackdrop) : AssetImage(Util.instance.imgPlaceHolder),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black87.withOpacity(0.7), BlendMode.darken),
            onError: (exception, stackTrace) {
              return AssetImage(Util.instance.imgPlaceHolder);
            },
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildPosterTitle(context),
            Expanded(
              child: _buildDescricao(context),
            ),
            _buildFavoriteAndRating(context),
          ],
        ),
      ),
      onTap: (){
        AppService.instance.navigateTo(MovieTab(movieModel));
      },
    );
  }

  Widget _buildPosterTitle(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FadeInImage(
                image: movieModel.urlImgPoster != null ? NetworkImage(movieModel.urlImgPoster) : AssetImage(Util.instance.imgPlaceHolder),
                placeholder: AssetImage(Util.instance.imgPlaceHolder),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            movieModel.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDescricao(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            movieModel.overview,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
          Spacer(flex: 1),
          Text(
            'Lançamento: ${Util.instance.retornarDataPadraoBR(movieModel.releaseDate)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteAndRating(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: FactoryFavoriteWidget(movieModel.id, 18),
          onPressed: (){
            bloc.saveFavorite(movieModel);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            '${Util.instance.formatDouble(movieModel.voteAverage)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}