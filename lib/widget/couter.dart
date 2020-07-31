import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(6),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.26),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Countup(
            textAlign: TextAlign.center,
            begin: number / 9,
            end: number.toDouble(),
            duration: Duration(seconds: 2),
            separator: '.',
            style: TextStyle(
              fontSize: 26,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
