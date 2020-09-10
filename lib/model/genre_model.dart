import 'package:flutter/material.dart';

class GenreModel {
  final int id;
  final String name;

  GenreModel({
    @required this.id,
    @required this.name,
  })  : assert(id != null && !id.isNaN && id >= 0),
        assert(name != null);

  Map<String, dynamic> toMap() {
    return {
      'codigo': id,
      'name': name,
    };
  }

  factory GenreModel.fromMap(Map<String, dynamic> map) {
    return GenreModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
