import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/movie_tab_bloc.dart';
import 'package:fluttermovie/model/movie_model.dart';

class MovieGenreWidget extends StatelessWidget {
  final MovieModel movieModel;
  final MovieTabBloc movieTabBloc;
  MovieGenreWidget(this.movieModel, this.movieTabBloc);
  @override
  Widget build(BuildContext context) {
    final text = movieTabBloc.getTextGenre(movieModel.genreIds);
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
          style: TextStyle(fontSize: 14.5),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
