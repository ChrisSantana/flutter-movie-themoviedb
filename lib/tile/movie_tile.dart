import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/movie_model.dart';

class MovieTile extends StatelessWidget {
  final MovieModel movieModel;

  const MovieTile(this.movieModel) : assert(movieModel != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
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
    );
  }
}
