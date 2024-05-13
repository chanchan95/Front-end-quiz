import 'package:flutter/material.dart';

class PtitLogo extends StatelessWidget {
  final double size;
  
  const PtitLogo({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ptit_logo.png',
      width: size,
      height: size,
    );
  }
}