import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final double size;
  final Color color;

  Indicator({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 16.0,
        height: size ?? 16.0,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              this.color ?? Color(0xFFd8d8df)),
        ),
      ),
    );
  }
}
