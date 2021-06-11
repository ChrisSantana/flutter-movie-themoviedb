import 'package:flutter/material.dart';
import 'package:fluttermovie/enum/enum_screen.dart';

class ScreenModel {
  final ScreenEnum position;
  final String name;
  final IconData icon;

  ScreenModel(this.position, this.name, this.icon);

  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'name': name,
    };
  }
}
