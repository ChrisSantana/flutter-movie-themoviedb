import 'package:flutter/material.dart';
import '../enum/enum_app_retorno.dart';

class AppRetornoModel {
  AppRetornoEnum state;
  dynamic data;
  
  AppRetornoModel({
    @required this.state,
    @required this.data,
  });

  factory AppRetornoModel.fromMap(Map<String, dynamic> map){
    return AppRetornoModel(
      state: map['state'], 
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state': state,
      'data': data, 
    };
  }

  AppRetornoModel toCopy() {
    return AppRetornoModel.fromMap(toMap());
  }
}