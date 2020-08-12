import 'package:flutter/material.dart';
import 'package:tim_demo/dto/coordinate.dart';

class JustTrianglePainter extends CustomPainter {
    Paint _paint;
    final Color color;
    final Coordinate point1;
    final Coordinate point2;

    JustTrianglePainter({
        @required this.color,
        @required this.point1,
        @required this.point2
    }) {
        _paint = Paint()
            ..style = PaintingStyle.fill
            ..color = color
            ..strokeWidth = 10
            ..isAntiAlias = true;
    }

    @override
    void paint(Canvas canvas, Size size) {
        var path = Path();
        path.moveTo(size.width, size.height);
        path.lineTo(point1.x, point1.y);
        path.lineTo(point2.x, point2.y);
        path.close();
        canvas.drawPath(path, _paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
        return true;
    }
}
