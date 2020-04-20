import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
    final double height;
    final Color color;
    final double horizontal;

    HorizontalLine({
        this.height = 0.5,
        this.color = const Color(0xFFEEEEEE),
        this.horizontal = 0.0,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            height: height,
            color: color,
            margin: EdgeInsets.symmetric(horizontal: horizontal),
        );
    }
}
