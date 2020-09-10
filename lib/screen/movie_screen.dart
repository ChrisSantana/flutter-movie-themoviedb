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

class MovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: Text(bloc.getScreenModel(ScreenEnum.movie)?.name ?? ''),
        showIconSearch: true,
        hintTextSearch: 'Informe o nome do filme',
        onListener: (value){
          print(value);
        },
      ),
      body: StreamBuilder<AppRetornoModel>(
        stream: bloc.streamRetornoAPI,
        initialData: AppRetornoModel(state: AppRetornoEnum.processando, data: null),
        builder: (_, snapshot) {
          final retornoModel = snapshot.data;
          if (retornoModel != null) {
            switch (retornoModel.state) {
              case AppRetornoEnum.processando:
                return Center(
                  child: ProgressIndicatorWidget(),
                );
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
      bottomNavigationBar: _buildBottomNavigator(context, bloc),
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

  Widget _buildBottomNavigator(BuildContext context, ApplicationBloc bloc) {
    return BottomAppBar(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildBtnAnterior(context, bloc),
            _buildPageFrom(bloc),
            _buildBtnProximo(context, bloc),
          ],
        ),
      ),
    );
  }

  Widget _buildBtnAnterior(BuildContext context, ApplicationBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.streamHabilitarBtnAnterior,
      builder: (_,snapshot){
        final habilitado = snapshot.data ?? false;
        return _buildFlatButton(
          context, 
          'Anterior', 
          habilitado ? bloc.onPressedAnterior : null,
        );
      },
    );
  }

  Widget _buildBtnProximo(BuildContext context, ApplicationBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.streamHabilitarBtnProximo,
      builder: (_,snapshot){
        final habilitado = snapshot.data ?? false;
        return _buildFlatButton(
          context, 
          'Próximo', 
          habilitado ? bloc.onPressedProximo : null,
        );
      },
    );
  }

  Widget _buildPageFrom(ApplicationBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.streamPageFrom,
      builder: (_,snapshot){
        final text = snapshot.data ?? '';
        return Text(text);
      },
    );
  }

  Widget _buildFlatButton(BuildContext context, String titulo, Function onPressed) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          width: 0.5,
        ),
      ),
      child: Text(
        titulo,
      ),
      onPressed: onPressed,
    );
  }
}
