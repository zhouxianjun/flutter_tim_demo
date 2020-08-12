import 'package:flutter/material.dart';
import 'package:tim_demo/components/just_triangle_painter.dart';
import 'package:tim_demo/dto/coordinate.dart';

class TriangleMessageWrapper extends StatelessWidget {
    final Widget child;
    final EdgeInsetsGeometry padding;

    TriangleMessageWrapper(this.child, {
        this.padding = const EdgeInsets.all(10.0)
    });

    @override
    Widget build(BuildContext context) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                CustomPaint(
                    size: Size(0, 10),
                    painter: JustTrianglePainter(
                        color: Colors.white,
                        point1: Coordinate(-5, 16),
                        point2: Coordinate(0, 21),
                    ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0)
                    ),
                    padding: padding,
                    child: child,
                )
            ],
        );
    }
}