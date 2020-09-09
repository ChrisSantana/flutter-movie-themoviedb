import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermovie/enum/enum_app_retorno.dart';
import 'package:fluttermovie/enum/enum_screen.dart';
import 'package:fluttermovie/library/util.dart';
import 'package:fluttermovie/model/app_retorno_model.dart';
import 'package:fluttermovie/tile/movie_tile.dart';
import 'package:fluttermovie/widget/geral/appbar_widget.dart';
import 'package:fluttermovie/widget/geral/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

import '../bloc/application_bloc.dart';

class PrincipalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: Text(bloc.getScreenModel(ScreenEnum.movie)?.name ?? ''),
      ),
      body: StreamBuilder<AppRetornoModel>(
        stream: bloc.streamRetornoAPI,
        initialData:
            AppRetornoModel(state: AppRetornoEnum.processando, data: null),
        builder: (_, snapshot) {
          final retornoModel = snapshot.data;
          if (retornoModel != null) {
            switch (retornoModel.state) {
              case AppRetornoEnum.processando:
                return ProgressIndicatorWidget();
                break;
              case AppRetornoEnum.concluido:
                return _buildContent(context, bloc);
                break;
              case AppRetornoEnum.erro:
              case AppRetornoEnum.none:
                return _buildError(context, bloc);
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ApplicationBloc bloc) {
    final list = bloc.listMovie;
    return list != null && list.isNotEmpty ? ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        return MovieTile(list.elementAt(index));
      },
    ) : _buildError(context, bloc);
  }

  Widget _buildError(BuildContext context, ApplicationBloc bloc) {
    return Center(
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.height * 0.3,
        child: RaisedButton(
          child: Text(Util.instance.nameButtonSplash),
          onPressed: bloc.requestAPI,
        ),
      ),
    );
  }
}
