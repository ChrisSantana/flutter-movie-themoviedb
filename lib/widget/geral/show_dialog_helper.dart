import 'package:flutter/material.dart';
import '../../repository/app_service.dart';
import '../../widget/geral/progress_indicator_widget.dart';

bool _isAlertOpen = false;

/// TODO verificar a necessidade deste arquivo
void showDialogBasic({
  @required Function onWillPopScope,
  bool exibirProgressIndicator: true,
  String msg: 'Processando...',
  EdgeInsets padding: const EdgeInsets.all(16),
  Widget child,
}) {
  _isAlertOpen = true;
  showDialog(
    context: AppService.instance.context,
    builder: (context) {
      return WillPopScope(
        onWillPop: onWillPopScope,
        child: AlertDialog(
          contentPadding: padding,
          content: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4, top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                exibirProgressIndicator ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  height: 16,
                  width: 16,
                  child: ProgressIndicatorWidget(strokeWidth: 2, color: Theme.of(context).buttonColor, radius: null,),
                ) : SizedBox.shrink(),
                Expanded(
                  child: child ?? Text(
                    msg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    barrierDismissible: false,
  );
}

Future<bool> showDialogConfirm({
  String title,
  String msg,
  String nomeButton: 'Confirmar',
  String nomeButtonCancelar: 'Cancelar',
  String nomeButtonSair: 'Sair',
  bool exibirButtonSair: false,
  double maxHeight: 66,
  EdgeInsets padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
}) async {
  _isAlertOpen = true;
  bool retornoAux = false;
  await showDialog(
    context: AppService.instance.context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async { return false; },
        child: AlertDialog(
          contentPadding: padding,
          title: Text(
            title,
          ),
          content: LimitedBox(
            maxHeight: maxHeight,
            child: Text(
              msg,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
          ),
          actions: <Widget>[
            Container(
              height: 32,
              child: exibirButtonSair ? FlatButton(
                child: Text(
                  nomeButtonSair,
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  retornoAux = null;
                },
              ) : SizedBox.shrink(),
            ),
            Container(
              height: 32,
              child: FlatButton(
                child: Text(
                  nomeButtonCancelar,
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  retornoAux = false;
                },
              ),
            ),
            Container(
              height: 32,
              child: FlatButton(
                child: Text(
                  nomeButton,
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  retornoAux = true;
                },
              ),
            ),
          ],
        ),
      );
    },
    barrierDismissible: false,
  );
  return retornoAux;
}

void closeAlert() {
  if (_isAlertOpen) {
    _isAlertOpen = false;
    AppService.instance.navigatePop();
  }
}