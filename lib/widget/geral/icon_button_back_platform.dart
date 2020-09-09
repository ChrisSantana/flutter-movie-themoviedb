import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class IconButtonBackPlatform extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final double size;
  IconButtonBackPlatform({
    @required this.onPressed,
    this.color,
    this.size: 22,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        color: color,
        size: size,
      ),
      onPressed: onPressed,
    );
  }
}
