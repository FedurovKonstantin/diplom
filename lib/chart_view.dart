import 'dart:ui';

import 'package:flutter/material.dart';

class CustomLineGraphPainter extends CustomPainter {
  List<double> data;

  CustomLineGraphPainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    double maxValue =
        data.reduce((value, element) => value > element ? value : element);
    double minValue =
        data.reduce((value, element) => value < element ? value : element);

    List<Offset> points = [];

    final yUnit = height / (maxValue - minValue);

    final linePaint = Paint();

    linePaint.strokeWidth = 1.0;
    linePaint.color = Colors.purple;

    for (int i = 0; i < data.length; i++) {
      double x = i * width / (data.length - 1);
      double y = (data[i] - minValue) * yUnit;

      points.add(Offset(x, y));
    }

    canvas.drawPoints(PointMode.polygon, points, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FlutterChartView extends StatelessWidget {
  final Iterable<double> data;

  const FlutterChartView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => CustomPaint(
        painter: CustomLineGraphPainter(
          data: data.toList(),
        ),
        size: Size(constraints.maxWidth, constraints.maxHeight),
        isComplex: true,
        willChange: true,
      ),
    );
  }
}
