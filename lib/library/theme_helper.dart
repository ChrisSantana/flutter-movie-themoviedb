import 'package:flutter/material.dart';

class ThemeHelper { 

  static final ThemeHelper _aparenciaHelper = ThemeHelper._internal();
  static ThemeHelper get instance { return _aparenciaHelper; }
  ThemeHelper._internal();
  
  ThemeData get classic {
    return ThemeData.light();
  }

  ThemeData get dark {
    return ThemeData.dark();
  }
}