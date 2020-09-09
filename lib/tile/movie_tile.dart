import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';
import 'package:fluttermovie/repository/app_service.dart';
import 'package:fluttermovie/tab/movie_tab.dart';
import 'package:transparent_image/transparent_image.dart';

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
            image: NetworkImage(movieModel.urlImBackdrop),
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
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: movieModel.urlImgPoster,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Util.instance.imgPlaceHolder,
                    fit: BoxFit.cover,
                  );
                },
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
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            movieModel.overview,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(icon: Icon(Icons.favorite), onPressed: (){}),
        Text(
          '${Util.instance.formatDouble(movieModel.voteAverage)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}