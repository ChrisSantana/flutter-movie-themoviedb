import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {

  final Color color;
  final double strokeWidth;
  final double radius;

  ProgressIndicatorWidget({this.color, this.strokeWidth: 2, this.radius: 28});

  @override
  Widget build(BuildContext context) {
    return circularProgressIndicator(context: context, cor: color, stroke: strokeWidth, rad: radius);
  }

  Widget circularProgressIndicator({@required BuildContext context, Color cor, double stroke, double rad}) {
    final circularProgress = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth ?? 3,
    );
    if (radius == null){
      return circularProgress;
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: radius,
        width: radius,
        child: circularProgress,
      );
    }
  }
}