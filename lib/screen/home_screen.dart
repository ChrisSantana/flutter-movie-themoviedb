import 'package:flutter/material.dart';
import 'movie_screen.dart';
import 'favorito_screen.dart';
import '../widget/geral/bottom_navigator_widget.dart';
import '../bloc/application_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: appBloc.pageController,
        children: <Widget>[
          MovieScreen(),
          FavoritoScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigatorWidget(),
    );
  }
}