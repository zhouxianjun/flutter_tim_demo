import 'package:flutter/material.dart';

class TabBarIcon extends StatelessWidget {
    final String img;

    TabBarIcon(this.img);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(bottom: 2.0),
            child: Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true)
        );
    }
}