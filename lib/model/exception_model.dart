import 'package:flutter/material.dart';

class ExceptionModel {
  final int codigo;
  final String msg;

  ExceptionModel({
    @required this.codigo,
    @required this.msg,
  })  : assert(codigo != null && !codigo.isNaN && codigo >= 0),
        assert(msg != null);

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'msg': msg,
    };
  }

  factory ExceptionModel.fromMap(Map<String, dynamic> map) {
    return ExceptionModel(
      codigo: map['codigo'],
      msg: map['msg'],
    );
  }
}
