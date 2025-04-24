import 'package:flutter/material.dart';

import 'bubble_widget.dart'; // your BubbleWidget class with .x, .y, .size, .color
import 'wave.dart'; // your WaveLayer class with .color, .offset, .svgData

/// A widget that displays a circular “bottle” of liquid, animated waves,
/// bubbles rising from bottom→top, and a glossy highlight.

/// The [CustomPainter] that does all the drawing.
class CustomCirclePainterWidget extends CustomPainter {
  final List<WaveLayer> waves;
  final List<BubbleWidget> bubbles;
  final double liquidLevel;
  final Color borderColor;
  final Color glossColor;

  CustomCirclePainterWidget({
    Listenable? repaint,
    required this.waves,
    required this.bubbles,
    required this.liquidLevel,
    required this.borderColor,
    this.glossColor = const Color(0x33FFFFFF),
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = size.center(Offset.zero);
    final circleRect = Rect.fromCircle(center: center, radius: radius);
    final circlePath = Path()..addOval(circleRect);

    // 1️⃣ Draw border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // 2️⃣ Clip all subsequent draws to the circle
    canvas.save();
    canvas.clipPath(circlePath);

    // 3️⃣ Draw waves & fill under the last wave
    for (var i = 0; i < waves.length; i++) {
      final wave = waves[i];
      final paint = Paint()..color = wave.color;

      // target wave size
      final desiredW = 15 * circleRect.width;
      final desiredH = 0.15 * circleRect.height;

      // horizontal shift
      final translateX =
          circleRect.left - wave.offset * (desiredW - circleRect.width);

      // vertical position: bottom minus (liquidLevel fraction × height) minus wave height
      final translateY =
          circleRect.bottom - (liquidLevel * circleRect.height) - desiredH;

      // build & apply transform
      final matrix =
          Matrix4.identity()
            ..translate(translateX, translateY)
            ..scale(
              desiredW / wave.svgData.getBounds().width,
              desiredH / wave.svgData.getBounds().height,
            );
      final path = wave.svgData.transform(matrix.storage);

      // draw wave
      canvas.drawPath(path, paint);

      // if this is the deepest wave, fill everything beneath it
      if (i == waves.length - 1) {
        final fillTop = translateY + desiredH;
        if (fillTop < circleRect.bottom) {
          canvas.drawRect(
            Rect.fromLTRB(
              circleRect.left,
              fillTop,
              circleRect.right,
              circleRect.bottom,
            ),
            paint,
          );
        }
      }
    }

    // 4️⃣ Draw bubbles (rising from bottom→top)
    for (final bubble in bubbles) {
      final paint = Paint()..color = bubble.color;

      // x: left→right
      final dx = circleRect.left + bubble.x * circleRect.width;

      // y: map bubble.y=0 → bottom-of-liquid, bubble.y=1 → top-of-liquid
      final dy =
          circleRect.bottom - bubble.y * (liquidLevel * circleRect.height);

      // bubble radius
      final bubbleRadius = bubble.size * radius;

      canvas.drawCircle(Offset(dx, dy), bubbleRadius, paint);
    }

    // 5️⃣ Glossy overlay
    final glossPaint = Paint()..color = glossColor;
    canvas.drawRect(circleRect, glossPaint);

    // restore (undo clip)
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomCirclePainterWidget old) => true;
}
