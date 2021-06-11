import 'package:flutter/material.dart';
import '../../bloc/application_bloc.dart';
import 'package:provider/provider.dart';

class BottomNavigatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = Provider.of<ApplicationBloc>(context);
    return StreamBuilder<int>(
      stream: appBloc.streamBottomNavigatorBar,
      initialData: 0,
      builder: (context, snap){
        return BottomNavigationBar(
          elevation: 10,
          currentIndex: snap.hasData ? snap.data : 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: appBloc.getListaScreenModel().map<BottomNavigationBarItem>((value){
            return _buildBottomNavigatorItem(value.icon, value.name);
          }).toList(),
          onTap: (index){
            _onTap(index, appBloc);
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigatorItem(IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 23,
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 4, right: 2),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onTap(int index, ApplicationBloc appBloc){
    appBloc.sinkBottomNavigatorBar(index);
  }
}