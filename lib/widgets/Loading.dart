// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double heightWidth;
  final Color color;
  const Loading({super.key, required this.heightWidth, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightWidth,
      width: heightWidth,
      child: CircularProgressIndicator(color: color),
    );
  }
}
