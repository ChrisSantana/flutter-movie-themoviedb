import 'package:flutter/material.dart';
import 'package:fluttermovie/bloc/application_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FactoryFavoriteWidget extends StatelessWidget {
  final int idMovie;
  final double sizeIcon;

  FactoryFavoriteWidget(this.idMovie, this.sizeIcon);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.streamAttFavorite,
      builder: (_, snapshot){
        return _buildIcon(bloc);
      }
    );
  }

  Widget _buildIcon(ApplicationBloc bloc) {
    return FutureBuilder<bool>(
      future: bloc.isFavoriteMovie(idMovie),
      builder: (_, snaphot){
        final isFavorite = snaphot.data ?? false;
        return Icon(
          isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          size: sizeIcon,
          color: Colors.white,
        );
      }
    );
  }
}