import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/application_bloc.dart';
import '../../enum/enum_app_retorno.dart';
import '../../model/app_retorno_model.dart';

class FactoryProgressSplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return StreamBuilder<AppRetornoModel>(
      stream: bloc.streamRetornoAPI,
      initialData: AppRetornoModel(state: AppRetornoEnum.processando, data: null),
      builder: (_, snapshot) {
        final retornoModel = snapshot.data;
        if (retornoModel != null) {
          switch (retornoModel.state) {
            case AppRetornoEnum.concluido:
            case AppRetornoEnum.processando:
              return _buildProgress();
              break;
            case AppRetornoEnum.erro:
            case AppRetornoEnum.none:
              return _buildError(context, bloc);
              break;
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildProgress() {
    return RotateAnimatedTextKit(
      duration: Duration(milliseconds: 1500),
      totalRepeatCount: 4,
      repeatForever: true,
      text: ['FLUTTER MOVIE', 'O MELHOR DO CINEMA', 'NA PALMA', 'DA SUA MÃO', 'CONFIRA OS PRINCIPAIS', 'LANÇAMENTOS', 'E OS SEUS', 'FILMES FAVORITOS'],
      textStyle: TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
      displayFullTextOnTap: false,
    );
  }

  Widget _buildError(BuildContext context, ApplicationBloc bloc) {
    return Center(
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.height * 0.3,
        child: RaisedButton(
          child: Text('Tentar novamente'),
          onPressed: bloc.init,
        ),
      ),
    );
  }
}