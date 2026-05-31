import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcdBuffer.dart';

class BoolGridPainter extends CustomPainter {
  final LcdBuffer lcdbuffer;
  final double cellSize;
  final Color trueColor;
  final Color falseColor;
  final Color borderColor;

  BoolGridPainter({
    required this.lcdbuffer,
    this.cellSize = 3,
    this.trueColor = const Color.fromARGB(255, 39, 58, 100),
    this.falseColor = const Color.fromARGB(255, 235, 234, 234),
    this.borderColor = const Color.fromARGB(255, 41, 10, 10),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = 0.1;

    double lcdW = lcdbuffer.cols.toDouble() * cellSize;
    double lcdH = lcdbuffer.rows.toDouble() * cellSize;

    var rect = Rect.fromLTRB(0, 0, lcdW + 30, lcdH + 45);
    paint.color = const Color.fromARGB(255, 177, 177, 177);
    canvas.drawRect(rect, paint);

    rect = Rect.fromLTRB(5, 0, lcdW + 30 - 5, lcdH + 40);
    paint.color = const Color.fromARGB(255, 8, 8, 8);
    canvas.drawRect(rect, paint);

    rect = Rect.fromLTRB(10, 30, lcdW + 30 - 10, lcdH + 35);
    paint.color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawRect(rect, paint);

    for (int c = 0; c < lcdbuffer.cols; c++) {
      for (int r = 0; r < lcdbuffer.rows; r++) {
        final x = c * cellSize + 10;
        final y = r * cellSize + 10;

        final rect = Rect.fromLTWH(x + 5, y + 22, cellSize, cellSize);

        paint.color = lcdbuffer.get(r, c) ? trueColor : falseColor;
        canvas.drawRect(rect, paint);
        // canvas.drawRect(rect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoolGridPainter oldDelegate) {
    return oldDelegate.lcdbuffer != lcdbuffer;
  }
}
