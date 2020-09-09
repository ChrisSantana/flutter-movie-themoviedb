import 'package:flutter/material.dart';
import 'package:fluttermovie/enum/enum_screen.dart';
import 'package:provider/provider.dart';

import '../bloc/application_bloc.dart';

class SobreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(bloc.getScreenModel(ScreenEnum.favorito)?.name ?? ''),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}