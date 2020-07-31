import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String title;
  final dynamic value;
  final Color colorBackground;
  Item({this.title, this.value, this.colorBackground});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: colorBackground,
        ),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Countup(
                textAlign: TextAlign.center,
                begin: value / 9,
                end: value.toDouble(),
                duration: Duration(seconds: 2),
                separator: '.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
