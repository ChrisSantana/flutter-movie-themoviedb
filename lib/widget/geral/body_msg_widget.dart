import 'package:flutter/material.dart';

import '../../library/util.dart';

class BodyMsgWidget extends StatelessWidget {

  final String msg;
  final Color color;
  final EdgeInsets padding;
  final exibirIconWarning;

  BodyMsgWidget({
    @required this.msg,
    this.color,
    this.padding,
    this.exibirIconWarning: true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: padding ?? const EdgeInsets.all(0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildIconWarning(context),
            _buildMsg(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWarning(BuildContext context) {
    if (!exibirIconWarning) return SizedBox.shrink();
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Image.asset(Util.instance.imgNotFound, fit: BoxFit.fill,),
    );
  }

  Widget _buildMsg(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: color ?? Theme.of(context).textTheme.caption.color,
        fontSize: 15.5,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
