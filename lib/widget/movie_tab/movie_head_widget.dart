import 'package:flutter/material.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';

class MovieHeadWidget extends StatelessWidget {
  final MovieModel movieModel;
  MovieHeadWidget(this.movieModel);
  @override
  Widget build(BuildContext context) {
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
                  _buildInformation(
                      'Título original: ${movieModel.originalTitle}', 0),
                  _buildInformation(
                      'Lançamento: ${Util.instance.retornarDataPadraoBR(movieModel.releaseDate)}'),
                  _buildInformation(
                      'Popularidade: ${Util.instance.formatDouble(movieModel.popularity)}'),
                  _buildInformation(
                      'Avaliação: ${Util.instance.formatDouble(movieModel.voteAverage)}'),
                ],
              ),
            ),
          ),
        ],
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
          fontSize: 14.5,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildFadeImage(String urlImg, BoxFit boxFit) {
    return FadeInImage(
      image: urlImg != null ? NetworkImage(urlImg) : AssetImage(Util.instance.imgPlaceHolder),
      placeholder: AssetImage(Util.instance.imgPlaceHolder),
      fit: boxFit,
    );
  }
}
