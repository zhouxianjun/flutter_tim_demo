import 'package:flutter/material.dart';
import 'package:tim_demo/components/just_triangle_painter.dart';
import 'package:tim_demo/dto/coordinate.dart';

class TriangleMessageWrapper extends StatelessWidget {
    final Widget child;
    final bool isSelf;
    final EdgeInsetsGeometry padding;

    TriangleMessageWrapper(this.child, {
        this.isSelf = false,
        this.padding = const EdgeInsets.all(10.0)
    });

    @override
    Widget build(BuildContext context) {
        List<Widget> list = [
            CustomPaint(
                size: Size(0, 10),
                painter: JustTrianglePainter(
                    color: Colors.white,
                    point1: Coordinate(isSelf ? 5 : -5, 16),
                    point2: Coordinate(0, 21),
                ),
            ),
            Flexible(
                fit: FlexFit.loose,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0)
                    ),
                    padding: padding,
                    child: child,
                ),
            )
        ];
        if (isSelf) {
            list = list.reversed.toList();
        }
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: list,
        );
    }
}