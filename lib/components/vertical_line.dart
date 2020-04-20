import 'package:flutter/material.dart';

class VerticalLine extends StatelessWidget {
    final double width;
    final double height;
    final Color color;
    final double vertical;

    VerticalLine({
        this.width = 1.0,
        this.height = 25,
        this.color = const Color.fromRGBO(209, 209, 209, 0.5),
        this.vertical = 0.0,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            width: width,
            color: Color(0xffDCE0E5),
            margin: EdgeInsets.symmetric(vertical: vertical),
            height: height,
        );
    }
}